#!/bin/sh

/etc/init.d/relay_outputs enable

/etc/init.d/openvpn enable

sleep 30
reboot
