#!/bin/sh
if [ -f /etc/openvpn/openvpn-enable.sh ]; then
  /etc/openvpn/openvpn-enable.sh;
  rm /etc/openvpn/openvpn-enable.sh;
fi
