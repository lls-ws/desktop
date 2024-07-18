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

transmission_conf()
{
	
	APP_NAME="transmission-daemon"
	
	FILE_SET="settings.json"
	
	DIR_ETC="/etc/${APP_NAME}"
	
	echo "Configure ${APP_NAME}..."
	
	service ${APP_NAME} stop
	
	if [ ! -f "${DIR_ETC}/${FILE_SET}.bak" ]; then
	
		cp -fv ${DIR_ETC}/${FILE_SET} ${DIR_ETC}/${FILE_SET}.bak
		
	fi
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc/${APP_NAME}"
	
	chown -v ${USER_TRANSMISISON}.${USER_TRANSMISISON} ${DIR_ETC}/${FILE_SET}
	
	DIR_TRANSMISSION="/home/torrents"
	
	if [ ! -d "${DIR_TRANSMISSION}" ]; then
	
		mkdir -pv ${DIR_TRANSMISSION}/.incomplete
	
	fi
	
	chown -Rv ${USER_TRANSMISISON}.${USER_TRANSMISISON} ${DIR_TRANSMISSION}
	
	systemctl disable ${APP_NAME}.service
	
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

	nfs_conf_dir
	
	cat ${DIR_ETC}/${FILE_SET}
	
	exportfs -rav
	
	service ${APP_NAME} stop
	
	systemctl disable ${APP_NAME}.service

}
	
nfs_conf_dir()
{
	
	DIR_HD="/mnt/hd_ext"
	
	if [ ! -d ${DIR_HD} ]; then
	
		mkdir -pv ${DIR_HD}
		
	fi
	
	DIR_SHD="/mnt/shared"
	
	if [ ! -d ${DIR_SHD} ]; then
	
		mkdir -p ${DIR_SHD}
		
	fi
	
	DIRS_SET=(
		"filmes"
		"series"
		"musica"
		"log"
	)
	
	for DIR_SET in "${DIRS_SET[@]}"
	do
		
		DIR_SET=${DIR_SHD}/${DIR_SET}
		
		if [ ! -d ${DIR_SET} ]; then
	
			mkdir -v ${DIR_SET}
			
		fi
			
	done
	
	chown -R ${USER_TRANSMISISON}.${USER_TRANSMISISON} ${DIR_SHD}
	
	chmod 777 ${DIR_SHD}
	
	ls -al ${DIR_SHD}
	
	exportfs -a
	
}

USER_TRANSMISISON="debian-transmission"

case "$1" in
	nfs)
		nfs_conf
		;;
	bluetooth)
		bluetooth_conf
		;;
 	sddm)
		sddm_conf
		;;
	lightdm)
		lightdm_conf
		;;
 	transmission)
		transmission_conf
		;;
	all)
		nfs_conf
		lightdm_conf
		transmission_conf
		;;
	*)
		echo "Use: $0 {all|nfs|bluetooth|sddm|lightdm|transmission}"
		exit 1
		;;
esac
