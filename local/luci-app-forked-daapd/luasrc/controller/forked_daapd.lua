-- Copyright 2012 Gabor Juhos <juhosg@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.forked_daapd", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/forked-daapd") then
		return
	end

	local page

	page = entry({"admin", "NAS", "forked_daapd"}, cbi("forked_daapd"), _("iTunes"))
	page.dependent = true
end
