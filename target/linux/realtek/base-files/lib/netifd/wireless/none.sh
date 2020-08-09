#!/bin/sh
. /lib/netifd/netifd-wireless.sh

init_wireless_driver "$@"

drv_none_init_device_config() {
	config_add_string path phy 'macaddr:macaddr'
	config_add_string hwmode
	config_add_int beacon_int chanbw frag rts
	config_add_int rxantenna txantenna antenna_gain txpower distance
	config_add_boolean noscan ht_coex
	config_add_array ht_capab
	config_add_array channels
	config_add_boolean \
		rxldpc \
		short_gi_80 \
		short_gi_160 \
		tx_stbc_2by1 \
		su_beamformer \
		su_beamformee \
		mu_beamformer \
		mu_beamformee \
		vht_txop_ps \
		htc_vht \
		rx_antenna_pattern \
		tx_antenna_pattern
	config_add_int vht_max_a_mpdu_len_exp vht_max_mpdu vht_link_adapt vht160 rx_stbc tx_stbc
	config_add_boolean \
		ldpc \
		greenfield \
		short_gi_20 \
		short_gi_40 \
		max_amsdu \
		dsss_cck_40
}

drv_none_init_iface_config() {

	config_add_string 'macaddr:macaddr' ifname

	config_add_boolean wds powersave
	config_add_int maxassoc
	config_add_int max_listen_int
	config_add_int dtim_period
	config_add_int start_disabled
}

none_add_capabilities() {
	local __var="$1"; shift
	local __mask="$1"; shift
	local __out= oifs

	oifs="$IFS"
	IFS=:
	for capab in "$@"; do
		set -- $capab

		[ "$(($4))" -gt 0 ] || continue
		[ "$(($__mask & $2))" -eq "$((${3:-$2}))" ] || continue
		__out="$__out[$1]"
	done
	IFS="$oifs"

	export -n -- "$__var=$__out"
}

none_get_addr() {
	local phy="$1"
	local idx="$(($2 + 1))"

	head -n $(($macidx + 1)) /sys/class/ieee80211/${phy}/addresses | tail -n1
}

none_generate_mac() {
	local phy="$1"
	local id="${macidx:-0}"

	local ref="$(cat /sys/class/ieee80211/${phy}/macaddress)"

    echo $ref
}

find_phy() {
	[ -n "$phy" -a -d /sys/class/ieee80211/$phy ] && return 0
	[ -n "$path" ] && {
		for phy in $(ls /sys/class/ieee80211 2>/dev/null); do
			case "$(readlink -f /sys/class/ieee80211/$phy/device)" in
				*$path) return 0;;
			esac
		done
	}
	[ -n "$macaddr" ] && {
		for phy in $(ls /sys/class/ieee80211 2>/dev/null); do
			grep -i -q "$macaddr" "/sys/class/ieee80211/${phy}/macaddress" && return 0
		done
	}
	return 1
}

none_check_ap() {
	has_ap=0
}

none_iw_interface_add() {
	local phy="$1"
	local ifname="$2"
	local type="$3"
	local wdsflag="$4"

	return 0
}

none_prepare_vif() {
	json_select config

	json_get_vars ifname mode ssid wds powersave macaddr

	[ -n "$ifname" ] || ifname="wlan${phy#phy}${if_idx:+-$if_idx}"
	if_idx=$((${if_idx:-0} + 1))

	set_default wds 0
	set_default powersave 0

	json_select ..

	[ -n "$macaddr" ] || {
		macaddr="$(none_generate_mac $phy)"
		macidx="$(($macidx + 1))"
	}

	json_add_object data
	json_add_string ifname "$ifname"
	json_close_object
	json_select config

	# It is far easier to delete and create the desired interface
	case "$mode" in
		sta)
			local wdsflag=
			staidx="$(($staidx + 1))"
			[ "$wds" -gt 0 ] && wdsflag="4addr on"
			none_iw_interface_add "$phy" "$ifname" managed "$wdsflag" || return
		;;
	esac

	json_select ..
}

none_setup_supplicant() {
	return 0
}

none_setup_vif() {
	local name="$1"
	local failed

	json_select data
	json_get_vars ifname
	json_select ..

	json_select config
	json_get_vars mode
	json_get_var vif_txpower txpower

	ip link set dev "$ifname" up || {
		wireless_setup_vif_failed IFUP_ERROR
		json_select ..
		return
	}

	set_default vif_txpower "$txpower"

	case "$mode" in
		sta)
			none_setup_supplicant || failed=1
		;;
	esac

	json_select ..
	[ -n "$failed" ] || wireless_add_vif "$name" "$ifname"
}

get_freq() {
	local phy="$1"
	local chan="$2"
	echo ${chan}00
}

none_interface_cleanup() {
    return 0
}

drv_none_cleanup() {
	return 0
}

drv_none_setup() {
	json_select config
	json_get_vars \
		phy macaddr path \
		country chanbw distance \
		txpower antenna_gain \
		rxantenna txantenna \
		frag rts beacon_int:100 htmode
	json_get_values basic_rate_list basic_rate
	json_select ..

	find_phy || {
		echo "Could not find PHY for device '$1'"
		wireless_set_retry 0
		return 1
	}

	wireless_set_data phy="$phy"
	none_interface_cleanup "$phy"

	# convert channel to frequency
	[ "$auto_channel" -gt 0 ] || freq="$(get_freq "$phy" "$channel")"

	no_ap=1
	macidx=0
	staidx=0

	set_default rxantenna all
	set_default txantenna all
	set_default distance 0
	set_default antenna_gain 0

	has_ap=
	hostapd_ctrl=
	for_each_interface "ap" none_check_ap

	for_each_interface "sta" none_prepare_vif
	for_each_interface "ap" none_prepare_vif

	for_each_interface "sta" none_setup_vif

	wireless_set_up
}

list_phy_interfaces() {
	local phy="$1"
	if [ -d "/sys/class/ieee80211/${phy}/device/net" ]; then
		ls "/sys/class/ieee80211/${phy}/device/net" 2>/dev/null;
	else
		ls "/sys/class/ieee80211/${phy}/device" 2>/dev/null | grep net: | sed -e 's,net:,,g'
	fi
}

drv_none_teardown() {
	wireless_process_kill_all

	json_select data
	json_get_vars phy
	json_select ..

	none_interface_cleanup "$phy"
}

add_driver none
