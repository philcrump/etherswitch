#!/usr/bin/lua

function gpio_init(address)
  os.execute("echo " .. tonumber(address)  .. " > /sys/class/gpio/export")                            
  os.execute("echo out > /sys/class/gpio/gpio" .. tonumber(address)  .. "/direction")
end

function gpio_output(address, state)
  os.execute("echo " .. tonumber(state) .. " >/sys/class/gpio/gpio" .. tonumber(address)  .. "/value")
end
