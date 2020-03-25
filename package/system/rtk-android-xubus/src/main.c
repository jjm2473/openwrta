/**
 *  Unix socket proxy base on epoll
 *  
 *  @author jjm2473
 *  @license MIT License
 *  
 *  Reference:
 *  https://gitee.com/ivan_allen/unp/blob/master/program/unixdomainprotocols/echo_stream/echo.cc
 *  https://github.com/converseai/converse_proxy/blob/master/proxy.c
 **/

#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/socket.h>
#include <errno.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/un.h>

#define BIND_ADDR "@/var/run/ubus.sock"
#define TARGET_ADDR "/var/run/ubus.sock"

#define MAX_EVENTS 20
#define BUFF_LEN 1024

#define perror(...) {}
//#define perror printf


struct Args
{
    int fd;
    int a;
    void *b;
};

/**
 * 
 * return 1 if should free context
 **/
typedef int (*Callback)(int epollfd, struct Args *ctx);

struct Context
{
    Callback cb;
    struct Args args;
};

int doforward(int from, int to)
{
    static char data[BUFF_LEN]; // we are running in single thread
    int rc;
    int wc;
    int n;
    while (1)
    {
        rc = read(from, data, BUFF_LEN);
        if (rc > 0)
        {
            // Now write this data to the other socket
            wc = rc;
            char *p = data;
            while (wc > 0)
            {
                n = write(to, p, wc);
                if (n == -1)
                {
                    if ((errno != EAGAIN) && (errno != EWOULDBLOCK))
                    {
                        return -2;
                    }
                }
                else if (n > 0)
                {
                    wc -= n;
                    p += n;
                }
            }
        }
        else if (rc == 0)
        { // EOF
            return -1;
        }
        else
        {
            if ((errno != EAGAIN) && (errno != EWOULDBLOCK))
            {
                return -2;
            }
            // All read back to main loop
            return 0;
        }
    }
}

int doCpoy(int epollfd, struct Args *args) // Callback
{
    static struct epoll_event dummy; // for http://man7.org/linux/man-pages/man2/epoll_ctl.2.html BUGS
    int ret = doforward(args->fd, args->a);

    if (ret == -2 || (ret == -1 && args->b == NULL))
    {
        // something wrong or both peer closed
        perror("destroy pair %d %d\n", args->fd, args->a);
        epoll_ctl(epollfd, EPOLL_CTL_DEL, args->fd, &dummy);
        epoll_ctl(epollfd, EPOLL_CTL_DEL, args->a, &dummy);
        close(args->fd);
        close(args->a);
        if (args->b != NULL) {
            free(args->b);
            args->b = NULL;
        }
        return 1; // let looper free context
    }
    else if (ret == -1) // peer eof
    {
        perror("sock eof %d\n", args->fd);
        epoll_ctl(epollfd, EPOLL_CTL_DEL, args->fd, &dummy);

        shutdown(args->a, SHUT_WR);
        ((struct Context*)(args->b))->args.b = NULL; // set flag to 1, means one peer closed
        return 1; // let looper free context
    }

    return 0;
}

int makePair(int epollfd, int sock1, int sock2)
{
    struct Context *ctx1 = (struct Context *)malloc(sizeof(struct Context));
    ctx1->cb = doCpoy;
    ctx1->args.fd = sock1;
    ctx1->args.a = sock2;
    ctx1->args.b = NULL;

    struct epoll_event ev;
    ev.events = EPOLLIN | EPOLLET;

    ev.data.ptr = ctx1;
    if (epoll_ctl(epollfd, EPOLL_CTL_ADD, sock1, &ev) == 0)
    {
        struct Context *ctx2 = (struct Context *)malloc(sizeof(struct Context));
        ctx2->cb = doCpoy;
        ctx2->args.fd = sock2;
        ctx2->args.a = sock1;
        ctx2->args.b = NULL;
        ev.data.ptr = ctx2;
        if (epoll_ctl(epollfd, EPOLL_CTL_ADD, sock2, &ev) == 0)
        {
            ctx1->args.b = ctx2;
            ctx2->args.b = ctx1;
            return 0;
        }
        else
        {
            epoll_ctl(epollfd, EPOLL_CTL_DEL, sock1, &ev);
            free(ctx2);
        }
    }

    free(ctx1);
    return -1;
}

int setnonblocking(int fd)
{
    int oldflags = fcntl(fd, F_GETFL, 0);
    /* If reading the flags failed, return error indication now. */
    if (oldflags == -1)
        return -1;
    /* Set just the flag we want to set. */
    oldflags |= O_NONBLOCK;
    /* Store modified flag word in the descriptor. */
    return fcntl(fd, F_SETFL, oldflags);
}

int connTarget(struct sockaddr *cliaddr, socklen_t len)
{
    int sock2 = socket(AF_LOCAL, SOCK_STREAM, 0);
    if (sock2 < 0)
    {
        return sock2;
    }

    if (connect(sock2, cliaddr, len) < 0 || setnonblocking(sock2) < 0)
    {
        close(sock2);
        return -1;
    }

    return sock2;
}

int doAccept(int epollfd, struct Args *args) // Callback
{
    struct sockaddr_un cliaddr;
    socklen_t len = sizeof(cliaddr);
    perror("accept %d\n", args->fd);
    int sockfd = accept(args->fd, (struct sockaddr *)&cliaddr, &len);
    if (sockfd < 0)
    {
        return 0;
    }
    perror("client connect %d\n", sockfd);
    if (setnonblocking(sockfd) >= 0)
    {
        cliaddr.sun_family = AF_LOCAL;
        strcpy(cliaddr.sun_path, TARGET_ADDR);
        len = SUN_LEN(&cliaddr);

        int sock2 = connTarget((struct sockaddr *)&cliaddr, len);
        if (sock2 >= 0)
        {
            if (makePair(epollfd, sockfd, sock2) < 0)
            {
                close(sock2);
            }
            else
            {
                perror("make pair %d %d\n", sockfd, sock2);
                return 0;
            }
        }
    }
    close(sockfd);
    return 0;
}

int mainLoop(int epollfd)
{
    int i;
    struct epoll_event events[MAX_EVENTS];
    for (;;)
    {
        int en = epoll_wait(epollfd, events, MAX_EVENTS, 5000);
        if (en < 0)
        {
            if ((errno != EAGAIN) && (errno != EWOULDBLOCK))
            {
                return errno;
            }
            perror("epoll_wait errno %d\n", errno);
            continue;
        }
        else if (en > 0)
        {

            for (i = 0; i < en; ++i)
            {
                struct Context* ctx = (struct Context*)(events[i].data.ptr);
                perror("get event %x %d\n", ctx->cb, ctx->args.fd);
                if (ctx->cb(epollfd, &(ctx->args)) == 1) {
                    free(ctx);
                }
            }
        }
    }
}

int main(int argc, char **argv, char **envp)
{
#define ERR_EXIT(msg)                 \
    {                                 \
        fprintf(stderr, "%s\n", msg); \
        if (ctx)                      \
        {                             \
            free(ctx);                \
        }                             \
        if (listenfd > 0)             \
        {                             \
            close(listenfd);          \
        }                             \
        if (epollfd > 0)              \
        {                             \
            close(epollfd);           \
        }                             \
        exit(1);                      \
    }

    int listenfd = 0;
    struct sockaddr_un servaddr;
    socklen_t len;
    struct Context *ctx = NULL;

    int epollfd = epoll_create1(EPOLL_CLOEXEC);

    if (epollfd < 0)
        ERR_EXIT("epoll_create1");

    len = sizeof(servaddr); // fix bug for ubus of realtek android, otherwise use SUN_LEN
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sun_family = AF_LOCAL;
    strcpy(servaddr.sun_path, BIND_ADDR);
    // len = SUN_LEN(&servaddr);
    servaddr.sun_path[0] = '\0';

    umask(0111);

    listenfd = socket(AF_LOCAL, SOCK_STREAM, 0);
    if (listenfd < 0)
        ERR_EXIT("socket");

    if (setnonblocking(listenfd) < 0)
        ERR_EXIT("nonblocking");

    int opt=1;
    if (setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) < 0) 
        ERR_EXIT("setsockopt");

    if (bind(listenfd, (struct sockaddr *)&servaddr, len) < 0)
        ERR_EXIT("bind");

    if (listen(listenfd, 10) < 0)
        ERR_EXIT("listen");

    struct epoll_event event;
    event.events = EPOLLIN | EPOLLERR;
    ctx = (struct Context *)malloc(sizeof(struct Context));
    ctx->cb = doAccept;
    ctx->args.fd = listenfd;
    event.data.ptr = ctx;

    if (epoll_ctl(epollfd, EPOLL_CTL_ADD, listenfd, &event) == -1)
        ERR_EXIT("epoll_ctl");

    struct sigaction sa;
    sa.sa_handler = SIG_IGN;
    sigaction(SIGPIPE, &sa, 0); 

    perror("listenfd %d\n", listenfd);
    perror("doAccept addr %x\n", doAccept);
    perror("doCopy addr %x\n", doCpoy);
    mainLoop(epollfd);

    free(ctx);
    close(listenfd);
    close(epollfd);
    return 0;
}