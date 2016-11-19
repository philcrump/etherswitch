#!/usr/bin/lua

--

local wantedgit = arg[1]

if wantedgit == nil or wantedgit == ''
then
  print("Error - no gitref passed to script (Usage: upgrade.lua [gitref])")
  os.exit(1)
end

-- Download FW Image
if 0 == os.execute("cd /tmp && wget 'https://netswitch.philcrump.co.uk/fw/ghy99/" .. wantedgit .. ".bin'")
then
  print("Image Download OK")
else
  print("Image Download Failed")
  os.exit(1)
end

-- Download FW Checksum
if 0 == os.execute("cd /tmp && wget 'https://netswitch.philcrump.co.uk/fw/ghy99/" .. wantedgit .. ".md5'")
then
  print("md5sum Download OK")
else
  print("md5sum Download Failed")
  os.exit(1)
end

-- Verify FW Checksum
if 0 == os.execute("cd /tmp && md5sum -c " .. wantedgit .. ".md5")
then
  print("md5sum Check OK")
else
  print("md5sum Check Failed")
  os.exit(1)
end

-- Flash FW and reboot!
if 0 == os.execute("cd /tmp && sysupgrade -v /tmp/".. wantedgit .. ".bin")
then
  -- Probably rebooted by now
  print("FW Upgrade OK")
else
  print("FW Upgrade Failed")
  os.exit(1)
end
