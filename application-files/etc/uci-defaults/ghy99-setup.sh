#!/bin/sh

ROOT_PASSWORD="etherswitch"

/etc/init.d/openvpn enable
/etc/init.d/openvpn start

/etc/init.d/enable_gpio enable
/etc/init.d/enable_gpio start

(echo "$ROOT_PASSWORD"; sleep 1; echo "$ROOT_PASSWORD")|passwd
