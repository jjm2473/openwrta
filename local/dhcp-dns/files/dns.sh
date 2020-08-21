#!/bin/sh

[ -L /sbin/udhcpc ] || exit 0

. /lib/functions.sh
. ../netifd-proto.sh
init_proto "$@"

proto_dns_init_config() {
	renew_handler=1

	proto_config_add_string 'ipaddr:ipaddr'
	proto_config_add_string 'hostname:hostname'
	proto_config_add_string clientid
	proto_config_add_string vendorid
	proto_config_add_boolean 'broadcast:bool'
	proto_config_add_boolean 'release:bool'
	proto_config_add_string 'reqopts:list(string)'
	proto_config_add_boolean 'defaultreqopts:bool'
	proto_config_add_string iface6rd
	proto_config_add_array 'sendopts:list(string)'
	proto_config_add_boolean delegate
	proto_config_add_string zone6rd
	proto_config_add_string zone
	proto_config_add_string mtu6rd
	proto_config_add_string customroutes
	proto_config_add_boolean classlessroute
}

proto_dns_add_sendopts() {
	[ -n "$1" ] && append "$3" "-x $1"
}

proto_dns_setup() {
	logger -t dns.sh setup $1 $2
	local config="$1"
	local iface="$2"

	local ipaddr hostname clientid vendorid broadcast release reqopts defaultreqopts iface6rd sendopts delegate zone6rd zone mtu6rd customroutes classlessroute
	json_get_vars ipaddr hostname clientid vendorid broadcast release reqopts defaultreqopts iface6rd delegate zone6rd zone mtu6rd customroutes classlessroute

	[ -n "$zone" ] && proto_export "ZONE=$zone"
	proto_export "INTERFACE=$config"

	if [ -f /android/.ottwifi -o -f /rom/android/.ottwifi ]; then
		proto_export "interface=$iface"
		proto_run_command "$config" sh /lib/netifd/dns.script reload -i $iface
		return 0
	fi

	local opt dhcpopts
	for opt in $reqopts; do
		append dhcpopts "-O $opt"
	done

	json_for_each_item proto_dns_add_sendopts sendopts dhcpopts

	[ -z "$hostname" ] && hostname="$(cat /proc/sys/kernel/hostname)"
	[ "$hostname" = "*" ] && hostname=

	[ "$defaultreqopts" = 0 ] && defaultreqopts="-o" || defaultreqopts=
	[ "$broadcast" = 1 ] && broadcast="-B" || broadcast=
	[ "$release" = 1 ] && release="-R" || release=
	[ -n "$clientid" ] && clientid="-x 0x3d:${clientid//:/}" || clientid="-C"

	[ -n "$iface6rd" ] && proto_export "IFACE6RD=$iface6rd"
	[ "$iface6rd" != 0 -a -f /lib/netifd/proto/6rd.sh ] && append dhcpopts "-O 212"
	[ -n "$zone6rd" ] && proto_export "ZONE6RD=$zone6rd"
	[ -n "$mtu6rd" ] && proto_export "MTU6RD=$mtu6rd"
	[ -n "$customroutes" ] && proto_export "CUSTOMROUTES=$customroutes"
	[ "$delegate" = "0" ] && proto_export "IFACE6RD_DELEGATE=0"
	# Request classless route option (see RFC 3442) by default
	[ "$classlessroute" = "0" ] || append dhcpopts "-O 121"

	proto_run_command "$config" udhcpc \
		-p /var/run/udhcpc-$iface.pid \
		-s /lib/netifd/dhcp.script \
		-f -t 0 -T 4 -i "$iface" \
		${ipaddr:+-r $ipaddr} \
		${hostname:+-x "hostname:$hostname"} \
		${vendorid:+-V "$vendorid"} \
		$clientid $defaultreqopts $broadcast $release $dhcpopts
}

proto_dns_renew() {
	logger -t dns.sh renew $1 $2
	if [ -f /android/.ottwifi -o -f /rom/android/.ottwifi ]; then
		return 0
	fi
	local interface="$1"
	# SIGUSR1 forces udhcpc to renew its lease
	local sigusr1="$(kill -l SIGUSR1)"
	[ -n "$sigusr1" ] && proto_kill_command "$interface" $sigusr1
}

proto_dns_teardown() {
	logger -t dns.sh teardown $1 $2
	if [ -f /android/.ottwifi -o -f /rom/android/.ottwifi ]; then
		proto_kill_command "$1" `kill -l SIGINT`
		local PIDFILE=/var/run/dns-$2.pid
		if [ -f $PIDFILE ]; then
			local PID=`cat $PIDFILE`
			kill -s SIGINT $PID
			while kill -0 $PID; do
				sleep 1
			done
			rm -f $PIDFILE
		fi
		INTERFACE=$1 interface=$2 sh /lib/netifd/dns.script deconfig -i $iface
		return 0
	fi
	local interface="$1"
	proto_kill_command "$interface"
}

add_protocol dns
