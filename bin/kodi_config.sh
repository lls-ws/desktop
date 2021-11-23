#!/bin/sh
# Script Configure Kodi Media Center on Kali Linux
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

kodi_grub()
{
	
	echo "Set time 0 to Grub..."
	
	FILE="/etc/default/grub"
	
	sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' ${FILE}
	
	cat ${FILE}

	update-grub
	
}

kodi_config()
{
	
	echo "Removing some directories..."
	
	DIR="/home/lls"
	
	rmdir -v "${DIR}/Área de trabalho" "${DIR}/Downloads" "${DIR}/Documentos" "${DIR}/Imagens" "${DIR}/Música" "${DIR}/Modelos" "${DIR}/Público"
	
	ls ${DIR}
	
}

kodi_install()
{

	echo "Install Essencial Apps..."
	
	apt-get -y install mcedit kodi kodi-inputstream-adaptive
	
}

kodi_nfs()
{
	echo "Mount a nfs shared..."
	
	HOST="dell"
	
	FILE="/etc/fstab"
	
	echo "${HOST}:/mnt/windows/Videos /home/lls/Vídeos/  nfs  noauto,x-systemd.automount  0  0" >> ${FILE}
	
	cat ${FILE}

}

kodi_login()
{
	
	echo "Configuring auto login..."
	
	echo "Changing lightdm configuration..."
	
	FILE="/etc/lightdm/lightdm.conf"
	
	sed -i 's/#autologin-user=/autologin-user=lls/g' ${FILE}
	sed -i 's/#autologin-session=/autologin-session=Kodi/g' ${FILE}
	sed -i 's/#autologin-user-timeout=0/autologin-user-timeout=0/g' ${FILE}
	
	cat ${FILE}
	
	echo "Create a custom configuration file:"
	
	mkdir -v /etc/lightdm/lightdm.conf.d/
	
	FILE="/etc/lightdm/lightdm.conf.d/50-myconfig.conf"
	
	echo "[SeatDefaults]" > ${FILE}
	echo "autologin-user=lls" >> ${FILE}
	echo "autologin-session=Kodi" >> ${FILE}
	echo "autologin-user-timeout=0" >> ${FILE}
	
	cat ${FILE}
	
}

kodi_hdmi()
{

	echo "Disable monitor LCD..."
	
	FILE="/etc/X11/xorg.conf.d/10-monitor.conf"
	
	echo 'Section "Monitor"'			> ${FILE}
	echo '	Identifier   "LVDS"' 		>> ${FILE}
	echo '	Option "Disable" "true"' 	>> ${FILE}
	echo 'EndSection'					>> ${FILE}
	
	cat ${FILE}
	
}

if [ `id -u` -ne 0 ]; then
	echo "Run script as root"
	exit 1
fi

case "$1" in
	ssh)
		bash bin/kali_config.sh "$1"
		;;
	hosts)
		bash bin/kali_config.sh "$1"
		;;	
	upgrade)
		bash bin/kali_config.sh "$1"
		;;
	locale)
		bash bin/kali_config.sh "$1"
		;;
	grub)
		bash bin/kali_config.sh "$1"
		kodi_grub
		;;
	config)
		kodi_config
		;;
	install)
		kodi_install
		;;
	nfs)
		kodi_nfs
		;;
	login)
		kodi_login
		;;
	hdmi)
		kodi_hdmi
		;;
	all)
		bash bin/kali_config.sh "ssh"
		bash bin/kali_config.sh "hosts"
		bash bin/kali_config.sh "upgrade"
		bash bin/kali_config.sh "locale"
		bash bin/kali_config.sh "grub"
		kodi_grub
		kodi_config
		kodi_install
		kodi_nfs
		kodi_login
		kodi_hdmi
		reboot
		;;
	*)
		echo "Use: $0 {all|ssh|hosts|upgrade|locale|grub|config|install|nfs|login|hdmi}"
		exit 1
		;;
esac
