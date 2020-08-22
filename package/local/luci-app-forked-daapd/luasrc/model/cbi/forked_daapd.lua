-- Copyright 2012 Gabor Juhos <juhosg@openwrt.org>
-- Licensed to the public under the Apache License 2.0.
require("nixio.fs")
local m, s, o
m = Map("forked-daapd", "iTunes Server",
	translate("iTunes (DAAP) server for Apple Remote and AirPlay."))

m:section(SimpleSection).template  = "forked_daapd_status"

s = m:section(TypedSection, "forked-daapd", translate("Settings"))
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enable"))
o.rmempty = false

o = s:option(Value, "port", translate("Port:"))
o.datatype = "port"
o.default = 3689
o.placeholder = "3689"
o.rmempty = false

servername = s:option(Value, "name", translate("Server Name"))
servername.rmempty = true

path = s:option(DynamicList, "path", translate("Media directories:"))
path.rmempty = true
path.placeholder = "/mnt/music"

db_path = s:option(Value, "db_path", translate("Database Path"))
db_path.rmempty = true

return m
