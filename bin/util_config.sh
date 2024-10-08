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
	
	echo "127.0.0.1			localhost" 							> /etc/hosts
	echo "192.168.0.1		router.lls.net.br		router"		>> /etc/hosts
	echo "192.168.0.100		dell.lls.net.br			dell" 		>> /etc/hosts
	echo "192.168.0.200		3green.lls.net.br		3green" 	>> /etc/hosts
 	echo "192.168.0.7		leandro.lls.net.br		leandro"	>> /etc/hosts
 	echo "192.168.0.4		wanda.lls.net.br		wanda"		>> /etc/hosts
 	echo "192.168.0.3		tv.lls.net.br			tv"			>> /etc/hosts
 	echo "192.168.0.2		camera.lls.net.br		camera"		>> /etc/hosts
  	echo "18.231.77.9		app.lls.net.br			app"	 	>> /etc/hosts
	echo "18.231.77.9		funchal.lls.net.br		funchal" 	>> /etc/hosts
	echo "18.231.77.9		repository.lls.net.br		repository"	>> /etc/hosts
	echo "208.67.222.222		opendns.lls.net.br		opendns" 	>> /etc/hosts
	echo "208.67.220.220		opendns2.lls.net.br		opendns2" 	>> /etc/hosts
	
	cat /etc/hosts
	
}

grub_conf()
{
	
	cp -fv images/wallpaper.png /boot/grub/themes/kali/grub-4x3.png
	cp -fv images/wallpaper.png /boot/grub/themes/kali/grub-16x9.png
	
	update-grub
	
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
		"cloud_connect.sh"
		"jquery-lls.sh"
	)
	
	update_files "Configure" "${DIR_BIN}" "util"
	
}

case "$1" in
	sudo)
		sudo_conf
		;;
	grub)
		grub_conf
		;;
 	hosts)
		hosts_conf
		;;
	scripts)
		scripts_conf
		;;
	all)
		sudo_conf
		hosts_conf
		scripts_conf
		;;
	*)
		echo "Use: $0 {all|sudo|grub|hosts|scripts}"
		exit 1
		;;
esac
