#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("libgpio")
require("libstate")

product_file="/etc/product.json"

JSON = (loadfile "/www/api/libjson.lua")()

function product_info()
    -- eg. {"platform":"ar150","outputs":["14","16"]}
    local f = io.open(product_file, "r")
    local json = f:read()
    f:close()
    return JSON:decode(json)
end

for index, address in ipairs(product_info().outputs) do
    gpio_init(address)
    if state_read(index)
    then
        gpio_output(address, 1)
    end
end

state_writeboot()
