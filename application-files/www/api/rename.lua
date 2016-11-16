#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("libstate")
require("liburl")

vars = url_postquery(io.read("*all"))

output = tonumber(vars["output"])
name = tostring(vars["name"])

state_rename(output, name)

print("\r\n" .. state_readjson())
