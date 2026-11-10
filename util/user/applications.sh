#!/bin/sh
# Script to configure Applications on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_user "$1"

applications_conf()
{

	echo "Remove Local User Applications:"
	rm -rf ~/.${DIR_LOCAL}
	
	echo "Create Local User Applications:"
	mkdir -pv ~/.${DIR_LOCAL}
	
	echo "Copy Local User Applications:"
	cp -fv ${DIR_LOCAL}/* ~/.${DIR_LOCAL}
	
	echo "Removendo cache:"
	sudo rm -fv ${DIR_LIST}/*.cache
	
	echo "Update desktop database:"
  	sudo update-desktop-database ${DIR_LIST}
	
	applications_show
	
}

applications_show()
{

	echo "Show Local User Applications:"
	ls -alh ~/.${DIR_LOCAL}
	
}

DIR_LOCAL="local/share/applications"
DIR_LIST="/usr/share/applications"

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
