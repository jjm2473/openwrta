-- Copyright 2013 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local proto = luci.model.network:register_protocol("dns")

function proto.get_i18n(self)
	return luci.i18n.translate("DHCP client (DNS only)")
end

function proto.is_installed(self)
	return nixio.fs.access("/lib/netifd/proto/dns.sh")
end

function proto.opkg_package(self)
	return "dhcp-dns"
end
