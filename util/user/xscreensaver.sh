#!/bin/sh
# Script to configure Xscreensaver User Profile on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_user "$1"

xscreensaver_conf()
{

	FILE_NAME="xscreensaver"
	FILE_SOURCE="config/${FILE_NAME}"
	FILE_UPDATE=~/.${FILE_NAME}

	copy_home
	
	FILE_NAME="Xdefaults"
	FILE_SOURCE="config/${FILE_NAME}"
	FILE_UPDATE=~/.${FILE_NAME}

	copy_home
	
	xrdb ~/.${FILE_NAME}
	
	xscreensaver_show
	
}

xscreensaver_show()
{
	
	cat ${FILE_UPDATE} | grep -A6 "textMode"
	
}



case "$1" in
	conf)
		xscreensaver_conf
		;;
	show)
		xscreensaver_show
		;;
	*)
		echo "Use: $0 {conf|show}"
		exit 1
		;;
esac
