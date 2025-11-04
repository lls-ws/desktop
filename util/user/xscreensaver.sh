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

	copy_home
	
	xscreensaver_show
	
}

xscreensaver_show()
{
	
	cat ${FILE_UPDATE} | grep -A6 "textMode"
	
}

FILE_NAME="xscreensaver"
FILE_SOURCE="config/${FILE_NAME}"
FILE_UPDATE=~/.${FILE_NAME}

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
