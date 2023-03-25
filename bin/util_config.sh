#!/bin/sh
# Script to configure same utilitaries on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

sudo_conf()
{

	APP_NAME="sudoers.d"
		
	FILE_SET="lls_sudoers"

	DIR_ETC="/etc/${APP_NAME}"

	if [ ! -d ${DIR_ETC} ]; then

		mkdir -pv ${DIR_ETC}

	fi

	cp -fv etc/${APP_NAME}/${FILE_SET} ${DIR_ETC}/${FILE_SET}

	chmod -v 440 ${DIR_ETC}/${FILE_SET}

	ls -al ${DIR_ETC}/${FILE_SET}
}

scripts_conf()
{
	
	DIR_BIN="/usr/bin"
	
	FILES_SET=(
		"change_brightness.sh"
		"stream_record.sh"
		"cloud_connect.sh"
		"print_screen.sh"
		"terminal.sh"
		"crack.sh"
	)
	
	update_files "Configure" "${DIR_BIN}" "scripts"
	
}

pixmaps_conf()
{
	
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
	
	update_files "Configure" "/usr/share/${APP_NAME}" "images/pixmaps"
	
	update_file "wallpaper.png" "/usr/share/backgrounds" "images"
	
}

case "$1" in
	sudo)
		sudo_conf
		;;
	scripts)
		scripts_conf
		;;
	pixmaps)
		pixmaps_conf
		;;
	all)
		sudo_conf
		scripts_conf
		pixmaps_conf
		;;
	*)
		echo "Use: $0 {all|sudo|scripts|pixmaps}"
		exit 1
		;;
esac
