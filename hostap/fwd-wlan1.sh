#!/bin/bash
# fwd-wlan1.sh
# Enable forwarding...
if [ "$EUID" -ne 0 ]
  then echo -e "\e[00;35m"Please run as root"\e[00m"
  exit
fi
sysctl -w net.ipv4.ip_forward=1
iptables -P FORWARD ACCEPT
iptables --table nat -A POSTROUTING -o wlan1 -j MASQUERADE
exit 0
