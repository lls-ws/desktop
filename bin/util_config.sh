#!/bin/sh
# Script to configure same utilitaries on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

hosts_conf()
{
	
	echo "127.0.0.1				localhost" 							> /etc/hosts
	echo "192.168.0.1			router.lls.net.br		router"		>> /etc/hosts
	echo "192.168.0.100		    dell.lls.net.br			dell" 		>> /etc/hosts
	echo "192.168.0.110		    asus.lls.net.br			asus" 		>> /etc/hosts
 	echo "192.168.0.7		    leandro.lls.net.br		leandro"	>> /etc/hosts
 	echo "192.168.0.4		    wanda.lls.net.br		wanda"		>> /etc/hosts
 	echo "192.168.0.3		    tv.lls.net.br			tv"			>> /etc/hosts
 	echo "192.168.0.2		    camera.lls.net.br		camera"		>> /etc/hosts
	echo "18.228.3.148			funchal.lls.net.br		funchal" 	>> /etc/hosts
	echo "18.228.3.148			repository.lls.net.br	repository"	>> /etc/hosts
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
	
	cat ${DIR_ETC}/${FILE_SET}
}

scripts_conf()
{
	
	DIR_BIN="/usr/bin"
	
	FILES_SET=(
		"change_brightness.sh"
		"stream_record.sh"
		"cloud_connect.sh"
		"print_screen.sh"
		"video_copy.sh"
		"jquery-lls.sh"
		"terminal.sh"
		"youtube.sh"
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
		"firefox.xpm"
		"mousepad.xpm"
		"chromium.xpm"
		"shutdown.xpm"
		"mate-calc.xpm"
		"developer.xpm"
		"ristretto.xpm"
		"anonymous.xpm"
		"teamviewer.xpm"
		"homeoffice.xpm"
		"multimedia.xpm"
		"torbrowser.xpm"
		"print_screen.xpm"
	)
	
	update_files "Configure" "/usr/share/${APP_NAME}" "images/${APP_NAME}"
	
	update_file "wallpaper.png" "/usr/share/backgrounds" "images"
	
	cp -fv images/wallpaper.png /usr/share/images/fluxbox/debian-dark.png
	cp -fv images/wallpaper.png /usr/share/images/fluxbox/ubuntu-dark.png
	cp -fv images/wallpaper.png /usr/share/images/fluxbox/ubuntu-light.png
	cp -fv images/wallpaper.png /usr/share/images/fluxbox/fluxbox.png
	
}

grub_conf()
{
	
	sudo apt-get -y install grub-customizer
	
	sudo cp -fv images/wallpaper.png /usr/share/grub/themes/kali/grub-4x3.png
	sudo cp -fv images/wallpaper.png /usr/share/grub/themes/kali/grub-16x9.png
	
	sudo grub-customizer
	
}

lightdm_conf()
{
	
	sudo lightdm-gtk-greeter-settings
	
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
	grub)
		grub_conf
		;;
	lightdm)
		lightdm_conf
		;;
	all)
		sudo_conf
		hosts_conf
		scripts_conf
		pixmaps_conf
		;;
	*)
		echo "Use: $0 {all|sudo|grub|hosts|scripts|pixmaps|lightdm}"
		exit 1
		;;
esac
