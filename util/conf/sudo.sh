#!/bin/sh
# Script to configure SUDO on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

sudo_conf()
{

	echo "Configure ${FILE_SET}..."
	
	update_file "${FILE_SET}" "/${DIR_ETC}" "${DIR_ETC}"
	
	chmod -v 440 /${DIR_ETC}/${FILE_SET}

	ls -al /${DIR_ETC}/${FILE_SET}
	
	util_show
	
}

FILE_SET="lls_sudoers"
DIR_ETC="etc/sudoers.d"

case "$1" in
	conf)
		sudo_conf
		;;
	show)
		util_show
		;;
	*)
		echo "Use: $0 {conf|show}"
		exit 1
		;;
esac
