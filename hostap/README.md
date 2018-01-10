# hostap
Scripts to quickly confiure an AP on the RPI 3 or Zero W running Raspbian or Kali Rolling using hostapd and dnsmasq.

## make-ap.sh
An interactive shell script that will create the appropriate config files.

`./make-ap.sh`
	
## startap.sh
Script to start your custom AP.

`sudo ./startap.sh`

## startap-open.sh
Script to start an AP that has no password.

`sudo ./startap-open.sh`

## Autostart
Edit your `rc.local` file and add the following directly above `exit 0`.

`/bin/bash /home/pi/RPI-Scripts/hostap/startap.sh > /dev/null 2>&1 &`
