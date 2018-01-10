#!/bin/bash
# make-ap.sh
# By SoMuchCode/YetAnotherCoder

cdir=( pwd )
echo "Make AP"
echo "New AP Name (SSID)?"
read apname
echo "New AP Password?"
read appasswrd
if [ "$appasswrd" == "" ]; then
        echo "Open Wifi - No Password"
        tempvar="$apname"
else
        tempvar=$( wpa_passphrase $apname $appasswrd )
fi
echo "New AP Channel?"
read newchan
echo "New AP interface (default: wlan0)?"
read newint
if [ "$newint" == "" ]; then
        newint=wlan0
fi
echo "Country Code (default: US)?"
read coucode
if [ "$coucode" == "" ]; then
	coucode="US"
fi
# Write the config file(s)
if [ "$tempvar" == "$apname" ]; then
	echo "openwifi"
	echo "interface="$newint > hostapd-open.conf
	echo "driver=nl80211" >> hostapd-open.conf
	echo "ap_max_inactivity=300" >> hostapd-open.conf
	echo "ssid="$apname >> hostapd-open.conf
	echo "channel="$newchan >> hostapd-open.conf
	echo "country_code="$coucode >> hostapd-open.conf
else	
	wpsk=$( echo "$tempvar" | grep -m4 "psk=" | tail -n1 | xargs )
	echo "interface="$newint > hostapd-RPI3Kali.conf
	echo "driver=nl80211" >> hostapd-RPI3Kali.conf
	echo "ap_max_inactivity=300" >> hostapd-RPI3Kali.conf
	echo "ssid="$apname >> hostapd-RPI3Kali.conf
	echo "wpa_"$wpsk >> hostapd-RPI3Kali.conf
	echo "channel="$newchan >> hostapd-RPI3Kali.conf
	echo "wpa_key_mgmt=WPA-PSK" >> hostapd-RPI3Kali.conf
	echo "country_code="$coucode >> hostapd-RPI3Kali.conf
	echo "hw_mode=g" >> hostapd-RPI3Kali.conf
	echo "ieee80211n=1" >> hostapd-RPI3Kali.conf
	echo "wmm_enabled=1" >> hostapd-RPI3Kali.conf
	echo "wpa=2" >> hostapd-RPI3Kali.conf
	echo "rsn_pairwise=CCMP" >> hostapd-RPI3Kali.conf
	echo "wpa_pairwise=CCMP" >> hostapd-RPI3Kali.conf
	echo "auth_algs=1" >> hostapd-RPI3Kali.conf
	echo "macaddr_acl=0" >> hostapd-RPI3Kali.conf
	
	echo "interface="$newint > hostapd-PiZeroKali.conf
	echo "driver=nl80211" >> hostapd-PiZeroKali.conf
	echo "ap_max_inactivity=300" >> hostapd-PiZeroKali.conf
	echo "ssid="$apname >> hostapd-PiZeroKali.conf
	echo "wpa_"$wpsk >> hostapd-PiZeroKali.conf
	echo "channel="$newchan >> hostapd-PiZeroKali.conf
	echo "wpa=2" >> hostapd-PiZeroKali.conf
	echo "wpa_key_mgmt=WPA-PSK" >> hostapd-PiZeroKali.conf
	echo "wmm_enabled=1" >> hostapd-PiZeroKali.conf
	echo "wpa_pairwise=TKIP" >> hostapd-PiZeroKali.conf
	echo "rsn_pairwise=CCMP" >> hostapd-PiZeroKali.conf
	echo "auth_algs=1" >> hostapd-PiZeroKali.conf
	echo "macaddr_acl=0" >> hostapd-PiZeroKali.conf
fi

echo "AP file created, run with: ./startap.sh or ./startap-open.sh"
ls *.conf
exit 0
