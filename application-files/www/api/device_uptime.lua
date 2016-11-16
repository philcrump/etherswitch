#!/usr/bin/lua

uptime_filename="/proc/uptime"

JSON = (loadfile "/www/api/libjson.lua")()

local f = io.open(uptime_filename, "r")
local uptime = f:read()
f:close()

local up, idle = string.match(uptime, "([0-9]+[\.][0-9]+) ([0-9]+[\.][0-9]+)")

print("\r\n" .. JSON:encode({up=up, idle=idle}))
