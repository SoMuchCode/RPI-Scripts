#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo -e "\e[00;35m"Please run as root"\e[00m"
  exit
fi
killall dnsmasq
killall hostapd
monstop > /dev/null 2>&1 &
exit 0
