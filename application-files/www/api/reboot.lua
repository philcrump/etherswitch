#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("liburl")

vars = url_postquery(io.read("*all"))

if(tostring(vars["reboot"])=="reboot")
then
    print("\r\nSuccess")
    os.execute("reboot")
else
    print("\r\nError")
end
