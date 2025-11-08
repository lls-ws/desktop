#!/bin/sh
# Script to configure Applications on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

applications_conf()
{

	list_dir "${DIR_LIST}"
	
	echo "Update the desktop database"
  	update-desktop-database ${DIR_LIST}
	
	rm -fv ${DIR_LIST}/*.cache
	
	applications_show
	
	echo "Restart LXQT Panel"
  	lxqt-panel restart &
	
}

applications_show()
{

	ls -al "${DIR_LIST}"
	
}

DIR_LIST="usr/share/applications"

case "$1" in
	conf)
		applications_conf
		;;
	show)
		applications_show
		;;
	*)
		echo "Use: $0 {conf|show}"
		exit 1
		;;
esac
