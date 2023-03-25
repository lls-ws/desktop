#!/bin/sh
# Script to configure daemon service on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

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

scripts_install()
{
	
	update_file "wallpaper.png" "/usr/share/backgrounds" "images"
	
	update_file "change_brightness.sh" "/usr/bin" "bin"
	update_file "stream_record.sh" "/usr/bin" "bin"
	update_file "cloud_connect.sh" "/usr/bin" "bin"
	update_file "print_screen.sh" "/usr/bin" "bin"
	update_file "terminal.sh" "/usr/bin" "bin"
	update_file "crack.sh" "/usr/bin" "bin"
	
	cp -fv config/bash_aliases ${FILE_BASH}
	
	chown -v ${USER}.${USER} ${FILE_BASH}
	
	pixmaps_files
	
}

pixmaps_files()
{
	
	APP_NAME="pixmaps"
	
	FILES_SET=(
		"tools.xpm"
		"thunar.xpm"
		"parole.xpm"
		"reboot.xpm"
		"office.xpm"
		"network.xpm"
		"mousepad.xpm"
		"shutdown.xpm"
		"mate-calc.xpm"
		"developer.xpm"
		"ristretto.xpm"
		"anonymous.xpm"
		"homeoffice.xpm"
		"multimedia.xpm"
		"print_screen.xpm"
	)
	
	update_files "Configure" "/usr/share/${APP_NAME}" "images/${APP_NAME}"
	
}


transmission_install()
{
	
	transmission_file
	
	install_app
	
	echo "Configure ${APP_NAME}..."
	
	service ${APP_NAME} stop
	
	USER_TRANSMISISON="debian-transmission"
	
	if [ ! -f "${DIR_ETC}/${FILE_SET}.bak" ]; then
	
		cp -fv ${DIR_ETC}/${FILE_SET} ${DIR_ETC}/${FILE_SET}.bak
		
		usermod -a -G ${USER_TRANSMISISON} ${USER}
	
	fi
	
	groups ${USER}
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc/${APP_NAME}"
	
	chown -v ${USER_TRANSMISISON}.${USER_TRANSMISISON} ${DIR_ETC}/${FILE_SET}
	
	DIR_TRANSMISSION="/home/torrents"
	
	if [ ! -d "${DIR_TRANSMISSION}" ]; then
	
		mkdir -pv ${DIR_TRANSMISSION}/.incomplete
	
	fi
	
	chown -Rv ${USER_TRANSMISISON}.${USER_TRANSMISISON} ${DIR_TRANSMISSION}
	
	systemctl disable ${APP_NAME}.service
	
	service ${APP_NAME} start
	service ${APP_NAME} status
	
}

transmission_file()
{
	
	APP_NAME="transmission-daemon"
	
	FILE_SET="settings.json"
	
	DIR_ETC="/etc/${APP_NAME}"
	
}


update_files()
{

	MSG_TXT="$1"

	DIR_UPDATE="$2"
	DIR_SOURCE="$3"

	echo "${MSG_TXT} ${APP_NAME}..."

	for FILE_SET in "${FILES_SET[@]}"
	do
		
		update_file "${FILE_SET}" "${DIR_UPDATE}" "${DIR_SOURCE}"
			
	done
	
}

update_file()
{

	FILE_CONF="$1"
	
	DIR_APP="$2"
	DIR_CLOUD="$3"
	
	if [ ! -d ${DIR_APP} ]; then
	
		mkdir -pv ${DIR_APP}
		#chown -v ${USER}.${USER} ${DIR_APP}
	
	fi
	
	echo "Copy ${FILE_CONF} configuration..."
	
	rm -fv ${DIR_APP}/${FILE_CONF}
	
	cp -fv ${DIR_CLOUD}/${FILE_CONF} ${DIR_APP}
	
	#chown -v ${USER}.${USER} ${DIR_APP}/${FILE_CONF}
	
}

case "$1" in
	sudo)
		sudo_install
		;;
	scripts)
		scripts_install
		;;
	lightdm)
		lightdm_conf
		;;
	transmission)
		transmission_install
		;;
	all)
		lightdm_conf
		;;
	*)
		echo "Use: $0 {all|sudo|scripts|lightdm|transmission}"
		exit 1
		;;
esac
