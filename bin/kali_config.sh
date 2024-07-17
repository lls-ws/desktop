#!/bin/sh
# Script to install apps on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

case "$1" in
  	apps)
		bash bin/apps_install.sh all
		;;
  	daemon)
		bash bin/daemon_config.sh bluetooth
		;;
   	util)
		bash bin/util_config.sh all
		;;
	user)
		bash bin/user_config.sh geany
		bash bin/user_config.sh aliases
		;;
  	all)
		bash bin/apps_install.sh all
		bash bin/daemon_config.sh bluetooth
		bash bin/util_config.sh all
		bash bin/user_config.sh geany
		bash bin/user_config.sh aliases
  		rm -rf ~/desktop
		reboot
		;;
	*)
		echo "Use: $0 {all|apps|daemon|util|user}"
		exit 1
		;;
esac
