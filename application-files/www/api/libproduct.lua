#!/usr/bin/lua

product_file="/etc/product.json"

JSON = (loadfile "/www/api/libjson.lua")()

function product_info()
    -- eg. {"platform":"ar150","outputs":["14","16"]}
    local f = io.open(product_file, "r")
    local json = f:read()
    f:close()
    return JSON:decode(json)
end

function product_gpio(output)
    return product_info()["outputs"][output]
end
