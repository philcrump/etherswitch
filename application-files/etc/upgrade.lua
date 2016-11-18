#!/usr/bin/lua

--

JSON = (loadfile "/www/api/libjson.lua")()

local upgrade_progress = {log="", aborted=0}

function progress_update(logstring, aborted)
  upgrade_progress["log"] = upgrade_progress["log"] .. logstring .. "\n"
  upgrade_progress["aborted"] = aborted
  local f = io.open("/www/api/upgrade_state.json", "w+")
  f:write(JSON:encode(upgrade_progress))
  f:close()
end

local wantedgit = arg[1]

if wantedgit == nil or wantedgit == ''
then
  print("Error - no gitref passed to script (Usage: upgrade.lua [gitref])")
  progress_update("No gitref passed to script",1)
  os.exit()
end

progress_update("Updating to gitref " .. wantedgit,0)

-- Download FW Image
progress_update("Downloading Firmware Image..",0)
if 0 == os.execute("cd /tmp && wget 'https://netswitch.philcrump.co.uk/fw/ghy99/" .. wantedgit .. ".bin")
then
  print("Image Download OK")
  progress_update(" - Download Successful.",0)
else
  print("Image Download Failed")
  progress_update(" - Download Failed.",1)
  os.exit()
end

-- Download FW Checksum
progress_update("Downloading Firmware Checksum..",0)
if 0 == os.execute("cd /tmp && wget 'https://netswitch.philcrump.co.uk/fw/ghy99/" .. wantedgit .. ".md5")
then
  print("md5sum Download OK")
  progress_update(" - Download Successful.",0)
else
  print("md5sum Download Failed")
  progress_update(" - Download Failed.",1)
  os.exit()
end

-- Verify FW Checksum
progress_update("Verifying Firmware Checksum..",0)
if 0 == os.execute("cd /tmp && md5sum -c " .. wantedgit .. ".md5")
then
  print("md5sum Check OK")
  progress_update(" - Verification Successful.",0)
else
  print("md5sum Check Failed")
  progress_update(" - Verification Failed.",1)
  os.exit()
end

-- Flash FW and reboot!
progress_update("Flashing Firmware..",0)
if 0 == os.execute("cd /tmp && sysupgrade -v /tmp/".. wantedgit .. ".bin")
then
  -- Probably rebooted by now
  print("FW Upgrade OK")
  progress_update(" - Flash Successful.",0)
else
  print("FW Upgrade Failed")
  progress_update(" - Flash Failed.",1)
  os.exit()
end
