#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("liburl")

vars = url_postquery(io.read("*all"))

if vars["gitref"] == nil or vars["gitref"] == ''
then
    print("\r\nError")
    os.exit()
end

if(tostring(vars["upgrade"])=="upgrade")
then
    print("\r\nSuccess")
    os.execute("/etc/upgrade.lua " .. vars["gitref"] .. " &")
else
    print("\r\nError")
end
