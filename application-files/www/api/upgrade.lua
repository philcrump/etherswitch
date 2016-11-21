#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("liburl")

JSON = (loadfile "/www/api/libjson.lua")()

vars = url_postquery(io.read("*all"))

if vars["gitref"] == nil or vars["gitref"] == ''
then
   print("\r\n" .. JSON:encode({success=0, message="Missing gitref parameter"})) 
   os.exit()
end

if tostring(vars["upgrade"])=="upgrade"
then
    if 0 == os.execute("/etc/upgrade.lua " .. vars["gitref"])
    then
        print("\r\n" .. JSON:encode({success=1, message="Upgrade success"}))
    else
        print("\r\n" .. JSON:encode({success=0, message="Upgrade command failed"}))
    end
else
    print("\r\n" .. JSON:encode({success=0, message="Missing upgrade confirmation parameter"}))
end
