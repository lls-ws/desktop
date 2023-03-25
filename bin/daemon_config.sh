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
	
	USER_TRANSMISISON="debian-transmission"
	
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

case "$1" in
	lightdm)
		lightdm_conf
		;;
	transmission)
		transmission_conf
		;;
	all)
		lightdm_conf
		transmission_conf
		;;
	*)
		echo "Use: $0 {all|lightdm|transmission}"
		exit 1
		;;
esac
