# hostap
Scripts to quickly configure an AP on the RPI 3 or Zero W running Raspbian or Kali Rolling using hostapd and dnsmasq.

## make-ap.sh
An interactive shell script that will create the appropriate config files.

`./make-ap.sh`
	
## startap.sh
Script to start your custom AP.
If you want to automatically start forwarding, start it with `-fe` or `--forward-eth0` for the ethernet connection, `-fw` or `--forward-wlan1` for wireless (wlan1) forwarding.
`sudo ./startap.sh`

## startap-open.sh
Script to start an AP that has no password.
If you want to automatically start forwarding, start it with `-fe` or `--forward-eth0` for the ethernet connection, `-fw` or `--forward-wlan1` for wireless (wlan1) forwarding.

`sudo ./startap-open.sh`

## Autostart
Edit your `/etc/rc.local` file and add the following directly above `exit 0`.

`/bin/bash /home/pi/RPI-Scripts/hostap/startap.sh > /dev/null 2>&1 &`
