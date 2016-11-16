#!/usr/bin/lua

platform_filename="/etc/product.json"

local f = io.open(platform_filename, "r")
local platform = f:read()
f:close()

print("\r\n" .. platform)
