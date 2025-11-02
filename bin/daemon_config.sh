#!/bin/sh
# Script to configure daemon service on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

bluetooth_conf()
{
	
	APP_NAME="bluetooth"
	
	echo "Configure ${APP_NAME}..."
	
	systemctl enable ${APP_NAME}

 	systemctl start ${APP_NAME}

  	systemctl status ${APP_NAME}
	
}

sddm_conf()
{
	git clone https://github.com/RadRussianRus/sddm-slice.git
	
 	mv -v sddm-slice /usr/share/sddm/themes/sddm-slice
	
	FILE_SET="/etc/sddm.conf"
 	
  	echo "[Theme]" >> ${FILE_SET}
   	echo "Current=sddm-slice" >> ${FILE_SET}
	
    cat ${FILE_SET}
	
}

lightdm_conf()
{
	
	APP_NAME="lightdm"
	
	FILE_SET="slick-greeter.conf"
	
	DIR_ETC="/etc/${APP_NAME}"
	
	echo "Configure ${APP_NAME}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc/${APP_NAME}"
	
	apt -y purge gdm3 unity-greeter
	
	apt -y autoremove
	
	dpkg-reconfigure lightdm
	
	cat /etc/X11/default-display-manager
	
	cp -fv images/wallpaper.png /usr/share/backgrounds
	
}

nfs_conf()
{
	
	APP_NAME="nfs-server"
	
	FILE_SET="exports"
	
	DIR_ETC="/etc"
	
	echo "Configure ${APP_NAME}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc"

	systemctl is-enabled ${APP_NAME}

	systemctl status ${APP_NAME}

	shared_dir
	
	exportfs -a
	
	cat ${DIR_ETC}/${FILE_SET}
	
	exportfs -rav
	
	service ${APP_NAME} stop
	
	systemctl disable ${APP_NAME}.service

}

samba_conf()
{
	
	APP_NAME="samba"
	
	FILE_SET="smb.conf"
	
	DIR_ETC="/etc/${APP_NAME}"
	
	echo "Configure ${APP_NAME}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc/${APP_NAME}"
	
	shared_dir
	
	cat ${DIR_ETC}/${FILE_SET}
	
	systemctl disable smbd.service
	
	systemctl stop smbd.service
	
}

case "$1" in
	nfs)
		nfs_conf
		;;
	sddm)
		sddm_conf
		;;
	samba)
		samba_conf
		;;
	lightdm)
		lightdm_conf
		;;
	bluetooth)
		bluetooth_conf
		;;
 	all)
		nfs_conf
		sddm_conf
		samba_conf
		lightdm_conf
		bluetooth_conf
		;;
	*)
		echo "Use: $0 {all|nfs|sddm|samba|lightdm|bluetooth}"
		exit 1
		;;
esac
