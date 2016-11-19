#!/usr/bin/lua

uptime_filename="/proc/uptime"

JSON = (loadfile "/www/api/libjson.lua")()

-- UPTIME
local f = io.open(uptime_filename, "r")
local uptime = f:read()
f:close()
local up, idle = string.match(uptime, "([0-9]+[\.][0-9]+) ([0-9]+[\.][0-9]+)")

-- MEMORY
f = io.popen("free")
for line in f:lines() do
    local s     = string.match(line, "^(%w+:)")
    local t,f = string.match(line, "([%d]+)[%D]+[%d]+[%D]+([%d]+)")
    if (s == "Mem:") then -- Handle 1st line and broken regexp
        ram_size = t                                          
        ram_free = f
    end             
end    
f:close()
         
-- DISK
f = io.popen("df -P /")
for line in f:lines() do
    local t,f = string.match(line, "([%d]+)[%D]+[%d]+[%D]+([%d]+)[%D]+[%d]+%%")
    local m     = string.match(line, "%%[%s](.+)")                             
    if m == "/" then                              
        disk_size = t*1000
        disk_free = f*1000
    end                   
end    
f:close()
         
print("\r\n" .. JSON:encode({up=up, idle=idle, ram_size=ram_size, ram_free=ram_free, disk_size=disk_size, disk_free=disk_free}))
