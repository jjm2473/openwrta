-- Copyright 2012 Gabor Juhos <juhosg@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.forked_daapd", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/forked-daapd") then
		return
	end

	local page

	page = entry({"admin", "nas", "forked_daapd"}, cbi("forked_daapd"), _("iTunes"))
	page.dependent = true

	entry({"admin", "nas", "forked_daapd", "status"}, call("api_status")).leaf=true
end

function api_status()
	local e={}
	e.running=luci.sys.call("pgrep -x /usr/sbin/forked-daapd >/dev/null")==0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
