#!/usr/bin/lua

version_filename="/etc/version"

local f = io.open(version_filename, "r")
local version = f:read()
f:close()

print("\r\n" .. version)
