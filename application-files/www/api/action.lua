#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("libproduct")
require("libgpio")
require("libstate")
require("liburl")

vars = url_postquery(io.read("*all"))

output = tonumber(vars["output"])
action = tonumber(vars["action"])

-- Only switch relay if this is a state switch
if state_update(output, action)
then
    gpio_output(product_gpio(output),action)
end

print("\r\n" .. state_readjson())
