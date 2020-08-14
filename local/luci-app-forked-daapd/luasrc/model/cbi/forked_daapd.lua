-- Copyright 2012 Gabor Juhos <juhosg@openwrt.org>
-- Licensed to the public under the Apache License 2.0.
require("nixio.fs")
local m, s, o
m = Map("forked-daapd", "iTunes Server",
	translate("iTunes (DAAP) server for Apple Remote and AirPlay."))

s = m:section(TypedSection, "forked-daapd", translate("Settings"))
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enable"))
o.rmempty = false

servername = s:option(Value, "name", translate("Server Name"))
servername.rmempty = true

path = s:option(Value, "path", translate("Media Folder"))
path.rmempty = true

db_path = s:option(Value, "db_path", translate("Database Path"))
db_path.rmempty = true

return m
