#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("librelay")
require("libstate")

-- Only switch relay if this is a state switch
if state_update(2, 0)
then
    relay2(0)
end

print("\r\n" .. state_readjson())
