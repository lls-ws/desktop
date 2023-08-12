#!/bin/sh
# Script to configure same utilitaries on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

hosts_conf()
{
	
	echo "127.0.0.1				localhost" 							> /etc/hosts
	echo "192.168.15.1			router.lls.net.br		router"		>> /etc/hosts
	echo "192.168.15.200		dell.lls.net.br			dell" 		>> /etc/hosts
	echo "192.168.15.201		kodi.lls.net.br			kodi" 		>> /etc/hosts
 	echo "192.168.15.202		mia2.lls.net.br			mia2" 		>> /etc/hosts
 	echo "192.168.15.203		samsung.lls.net.br		samsung"	>> /etc/hosts
 	echo "192.168.15.210		asus.lls.net.br			asus" 		>> /etc/hosts
	echo "18.228.3.148			app.lls.net.br			app"		>> /etc/hosts
 	echo "15.228.191.206		repository.lls.net.br	repository"	>> /etc/hosts
	echo "15.228.191.206		funchal.lls.net.br		funchal" 	>> /etc/hosts
	echo "208.67.222.222		opendns.lls.net.br		opendns" 	>> /etc/hosts
	echo "208.67.220.220		opendns2.lls.net.br		opendns2" 	>> /etc/hosts
	
	cat /etc/hosts
	
}

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
		"video_copy.sh"
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
	
	APP_NAME="pixmaps"
	
	FILES_SET=(
		"vlc.xpm"
		"kodi.xpm"
		"tools.xpm"
		"thunar.xpm"
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
	
	update_file "wallpaper.png" "/usr/share/backgrounds" "images"
	
	cp -fv images/wallpaper.png /usr/share/images/fluxbox/ubuntu-dark.png
	cp -fv images/wallpaper.png /usr/share/images/fluxbox/ubuntu-light.png
	cp -fv images/wallpaper.png /usr/share/images/fluxbox/fluxbox.png
	
}

case "$1" in
	sudo)
		sudo_conf
		;;
	hosts)
		hosts_conf
		;;
	scripts)
		scripts_conf
		;;
	pixmaps)
		pixmaps_conf
		;;
	all)
		sudo_conf
		hosts_conf
		scripts_conf
		pixmaps_conf
		;;
	*)
		echo "Use: $0 {all|sudo|hosts|scripts|pixmaps}"
		exit 1
		;;
esac
