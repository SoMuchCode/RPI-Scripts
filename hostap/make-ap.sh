#!/bin/bash
# make-ap.sh
# By SoMuchCode/YetAnotherCoder

echo "Make AP"
echo "New AP Name (SSID)?"
read apname
echo "New AP Password (Enter for none)?"
read appasswrd
if [ "$appasswrd" == "" ]; then
        echo "Open Wifi - No Password"
        tempvar="$apname"
else
        tempvar=$( wpa_passphrase $apname $appasswrd )
fi
echo "New AP Channel (default: 1)?"
read newchan
if [ "$newchan" == "" ]; then
        newchan=1
fi
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
	echo "interface="$newint > hostapd-RPI3.conf
	echo "driver=nl80211" >> hostapd-RPI3.conf
	echo "ap_max_inactivity=300" >> hostapd-RPI3.conf
	echo "ssid="$apname >> hostapd-RPI3.conf
	echo "wpa_"$wpsk >> hostapd-RPI3.conf
	echo "channel="$newchan >> hostapd-RPI3.conf
	echo "wpa_key_mgmt=WPA-PSK" >> hostapd-RPI3.conf
	echo "country_code="$coucode >> hostapd-RPI3.conf
	echo "hw_mode=g" >> hostapd-RPI3.conf
	echo "ieee80211n=1" >> hostapd-RPI3.conf
	echo "wmm_enabled=1" >> hostapd-RPI3.conf
	echo "wpa=2" >> hostapd-RPI3.conf
	echo "rsn_pairwise=CCMP" >> hostapd-RPI3.conf
	echo "wpa_pairwise=CCMP" >> hostapd-RPI3.conf
	echo "auth_algs=1" >> hostapd-RPI3.conf
	echo "macaddr_acl=0" >> hostapd-RPI3.conf
	
	echo "interface="$newint > hostapd-PiZero.conf
	echo "driver=nl80211" >> hostapd-PiZero.conf
	echo "ap_max_inactivity=300" >> hostapd-PiZero.conf
	echo "ssid="$apname >> hostapd-PiZero.conf
	echo "wpa_"$wpsk >> hostapd-PiZero.conf
	echo "channel="$newchan >> hostapd-PiZero.conf
	echo "wpa=2" >> hostapd-PiZero.conf
	echo "wpa_key_mgmt=WPA-PSK" >> hostapd-PiZero.conf
	echo "wmm_enabled=1" >> hostapd-PiZero.conf
	echo "wpa_pairwise=TKIP" >> hostapd-PiZero.conf
	echo "rsn_pairwise=CCMP" >> hostapd-PiZero.conf
	echo "auth_algs=1" >> hostapd-PiZero.conf
	echo "macaddr_acl=0" >> hostapd-PiZero.conf
fi

echo "AP file created, run with: ./startap.sh or ./startap-open.sh"
ls *.conf
exit 0
