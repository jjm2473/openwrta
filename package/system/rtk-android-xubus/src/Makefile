CC ?= gcc
CFLAGS ?= -Wall
MAIN_OBJ = main.o

all: xubus

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

xubus: $(OBJS) $(MAIN_OBJ)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(MAIN_OBJ)

clean:
	rm -f xubus *.o
