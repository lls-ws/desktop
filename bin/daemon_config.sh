#!/bin/sh
# Script to configure daemon service on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

lightdm_conf()
{
	
	APP_NAME="lightdm"
	
	FILE_SET="${APP_NAME}-gtk-greeter.conf"
	
	DIR_ETC="/etc/${APP_NAME}"
	
	echo "Configure ${APP_NAME}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc/${APP_NAME}"
	
	dpkg-reconfigure lightdm
	
	cat /etc/X11/default-display-manager
	
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

	sudo systemctl is-enabled ${APP_NAME}

	sudo systemctl status ${APP_NAME}

	nfs_conf_dir
	
	cat ${DIR_ETC}/${FILE_SET}
	
	sudo exportfs -rav
	
	sudo service ${APP_NAME} restart
	
	systemctl disable ${APP_NAME}.service

}
	
nfs_conf_dir()
{
	
	DIR_SHD="/mnt/shared"
	
	if [ ! -d ${DIR_SHD} ]; then
	
		mkdir -p ${DIR_SHD}
		
	fi
	
	DIRS_SET=(
		"filmes"
		"series"
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
	
	sudo chmod 777 ${DIR_SHD}
	
	ls -al ${DIR_SHD}
	
	sudo exportfs -a
	
}

USER_TRANSMISISON="debian-transmission"

case "$1" in
	nfs)
		nfs_conf
		;;
	lightdm)
		lightdm_conf
		;;
	transmission)
		transmission_conf
		;;
	all)
		lightdm_conf
		transmission_conf
		nfs_conf
		;;
	*)
		echo "Use: $0 {all|nfs|lightdm|transmission}"
		exit 1
		;;
esac
