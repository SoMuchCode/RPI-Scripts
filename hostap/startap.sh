#!/bin/bash
# startap.sh
# By SoMuchCode/YetAnotherCoder
# https://github.com/SoMuchCode
# This works with my RPI3 running Kali
# I have to start the monitor mode or
# my Android tablet won't connect...
#
# On the Pi Zero W I don't have to start
# monitor mode...
#
# On Raspbian I don't have to either...
#
# To autostart this:
# nano /etc/rc.local
# /bin/bash /<your home directory>/RPI-Scripts/hostap/startap-open.sh > /dev/null 2>&1 &
#

if [ "$EUID" -ne 0 ]
  then echo -e "\e[00;35m"Please run as root"\e[00m"
  exit
fi

# Change this for your system!!!
script_directory=/home/pi/RPI-Scripts/hostap

myarch=$( arch )
date > $script_directory/ap-started.txt
ifconfig wlan0 10.100.0.1/24 up
killall dnsmasq
killall hostapd
if [ "$myarch" == "armv61" ]; then
	# Pi Zero
	echo "zero" > /dev/null
else
	# RPI 3
	monstart	# This command will fail on Raspbian, that's okay
	#iw phy phy0 interface add wlan0mon type monitor
fi
sleep 1
dnsmasq -C $script_directory/dnsmasq.conf -d &
sleep 1
if [ "$myarch" == "armv61" ]; then
	hostapd $script_directory/hostapd-PiZeroKali.conf &
else
	hostapd $script_directory/hostapd-RPI3Kali.conf &
fi
if [ "$1" == "--forward-eth0" ] || [ "$1" == "-fe" ] ; then
	sysctl -w net.ipv4.ip_forward=1
	iptables -P FORWARD ACCEPT
	iptables --table nat -A POSTROUTING -o eth0 -j MASQUERADE
fi
if [ "$1" == "--forward-wlan1" ] || [ "$1" == "-fw" ] ; then
	sysctl -w net.ipv4.ip_forward=1
	iptables -P FORWARD ACCEPT
	iptables --table nat -A POSTROUTING -o wlan1 -j MASQUERADE
fi
exit 0