#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("librelay")
require("libstate")

-- Only switch relay if this is a state switch
if state_update(1, 1)
then
    relay1(1)
end

print("\r\n" .. state_readjson())
