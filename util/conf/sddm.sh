#!/bin/sh
# Script to configure SDDM on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

sddm_conf()
{
	
	echo "Configure ${FILE_SET}..."
	
	update_file "${FILE_SET}" "/${DIR_ETC}" "${DIR_ETC}"
	
	util_show
	
}

FILE_SET="sddm.conf"
DIR_ETC="etc"

case "$1" in
	conf)
		sddm_conf
		;;
	show)
		util_show
		;;
	*)
		echo "Use: $0 {conf|show}"
		exit 1
		;;
esac
