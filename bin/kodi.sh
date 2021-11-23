#!/bin/sh
# Script Configure Kodi Media Center on Kali Linux
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

kodi_config()
{

	# Step 1 - Disable monitor LCD
	FILE="/etc/X11/xorg.conf.d/10-monitor.conf"
	
	echo 'Section "Monitor"'			> ${FILE}
	echo '	Identifier   "LVDS"' 		>> ${FILE}
	echo '	Option "Disable" "true"' 	>> ${FILE}
	echo 'EndSection'					>> ${FILE}
	
	cat ${FILE}
	
	# Step 2 - Mount a nfs shared
	IP="192.168.0.170"
	
	FILE="/etc/fstab"
	
	echo "${IP}:/mnt/windows/Videos /home/lls/Vídeos/  nfs  noauto,x-systemd.automount  0  0" >> ${FILE}
	
	cat ${FILE}
	
	# Step 3 - Auto login
	echo "Uncomment the following line:"
	echo "#autologin-user="
	
	echo "And add the user you want to autologin:"
	echo "#autologin-user=lls"
	
	mcedit /etc/lightdm/lightdm.conf
	
	echo "Create a custom configuration file:"
	
	mkdir -v /etc/lightdm/lightdm.conf.d/
	
	FILE="/etc/lightdm/lightdm.conf.d/50-myconfig.conf"
	
	echo "[SeatDefaults]" > ${FILE}
	echo "autologin-user=lls" >> ${FILE}
	
	reboot
	
}

if [ `id -u` -ne 0 ]; then
	echo "Run script as root"
	exit 1
fi

case "$1" in
	upgrade)
		bash bin/kali_config.sh "$1"
		;;
	locale)
		bash bin/kali_config.sh "$1"
		;;
	hosts)
		bash bin/kali_config.sh "$1"
		;;	
	kodi)
		kodi_config
		;;
	all)
		bash bin/kali_config.sh "upgrade"
		bash bin/kali_config.sh "locale"
		bash bin/kali_config.sh "hosts"
		
		;;
	*)
		echo "Use: $0 {all|upgrade|locale|hosts|kodi}"
		exit 1
		;;
esac
