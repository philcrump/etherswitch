#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("libstate")

print("\r\n" .. state_readjson())
