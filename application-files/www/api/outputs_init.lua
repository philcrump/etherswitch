#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("librelay")
require("libstate")

state_writeboot()

relay1_init()
relay2_init()

if state_read("1")
then
    relay1(1)
end

if state_read("2")
then
    relay2(1)
end
