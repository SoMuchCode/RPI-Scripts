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
#change to bash interpreter
#!/bin/bash
# /bin/bash /home/pi/scripts/hostap/startap.sh > /dev/null 2>&1 &
#

if [ "$EUID" -ne 0 ]
  then echo -e "\e[00;35m"Please run as root"\e[00m"
  exit
fi

# Change this for your system!!!
script_directory=/home/pi/scripts/hostap

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
exit 0