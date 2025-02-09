#!/bin/sh
# Script to configure Lubuntu on 3Green
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

clear

echo "Script to configure Wifi on 3Green"

list_wifi()
{
	
	echo "Check WiFi interface:"
	nmcli d
	
	echo "Make sure the WiFi radio is on:"
	nmcli r wifi on
	
	echo "List the available WiFi networks:"
	nmcli d wifi list
	
}

connect_wifi()
{
	
	echo "Connect to the access point:"
	nmcli d wifi connect Apto104 password Finotti104
	
	ping_wifi
	
}

check_wifi()
{
	
	echo "Check Wifi connection:"
	wavemon
	
	ping_wifi
	
}

ping_wifi()
{
	
	echo "Check Connection:"
	ping -W 3 -c 10 -4 router
	
}

driver_wifi()
{
	
	DEVICE="02:00.0"
	
	echo "Check WiFi driver:"
	lspci -k | grep -i wireless
	
	#lspci -vv -s ${DEVICE}
	
	#modinfo iwlwifi
	
	ls /lib/firmware | grep 7265
	
	#cd /lib/firmware
	#sudo cp -fv iwlwifi-7265D-13.ucode iwlwifi-3165-9.ucode
	#sudo cp -fv iwlwifi-7265-13.ucode  iwlwifi-3165-13.ucode
	
}

case "$1" in
  	driver)
		driver_wifi
		;;
  	list)
		list_wifi
		;;
  	connect)
		connect_wifi
		;;
  	check)
		check_wifi
		;;
	ping)
		ping_wifi
		;;
  	all)
		driver_wifi
		list_wifi
		connect_wifi
		check_wifi
		ping_wifi
		;;
	*)
		echo "Use: $0 {all|driver|list|connect|check|ping}"
		exit 1
		;;
esac
