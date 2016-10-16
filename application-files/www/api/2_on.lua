#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("librelay")
require("libstate")

-- Only switch relay if this is a state switch
if state_update(2, 1)
then
    relay2(1)
end

print("\r\n" .. state_readjson())
