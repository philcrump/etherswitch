#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("liburl")

vars = url_postquery(io.read("*all"))

if vars["gitref"] == nil or vars["gitref"] == ''
then
    print("\r\nError")
    os.exit()
end

print("\r\n")

if(tostring(vars["upgrade"])=="upgrade")
then
    os.execute("/etc/upgrade.lua " .. vars["gitref"])
else
    print("Error")
end
