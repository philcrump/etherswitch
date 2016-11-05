#!/usr/bin/lua

function sleep(n)                                                                             
  os.execute("sleep " .. tonumber(n))                                                         
end   

function relay1_init()
  os.execute("echo 14 > /sys/class/gpio/export")                            
  os.execute("echo out > /sys/class/gpio/gpio14/direction")
end

function relay1(state)                                                                      
  os.execute("echo " .. tonumber(state) .. " >/sys/class/gpio/gpio14/value")
end 

function relay2_init()
  os.execute("echo 16 > /sys/class/gpio/export")                            
  os.execute("echo out > /sys/class/gpio/gpio16/direction")
end

function relay2(state)
  os.execute("echo " .. tonumber(state) .. " >/sys/class/gpio/gpio16/value")
end
