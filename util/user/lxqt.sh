#!/bin/sh
# Script to Configure LXQT on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_user "$1"

lxqt_conf()
{
	
	set_app "${APP_NAME}"
	
	update_files_dir
	
	apps_show "${APP_NAME}"
	
	echo "Restart LXQT Panel"
  	lxqt-panel restart &
	
}

APP_NAME="lxqt"

case "$1" in
	conf)
		lxqt_conf
		lxqt-leave --logout
		;;
	show)
		apps_show "${APP_NAME}"
		;;
	all)
		lxqt_conf
  		;;
	*)
		echo "Use: $0 {all|conf|show}"
		exit 1
		;;
esac
