#!/bin/sh
# Script to configure HOSTS on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

hosts_conf()
{
	
	echo "Configure ${FILE_SET}..."
	
	update_file "${FILE_SET}" "/${DIR_ETC}" "${DIR_ETC}"
	
	util_show
	
	hosts_ping
	
}

hosts_ping()
{
	
	HOST="$1"
	
	if [ -z "${HOST}" ]; then
	
		HOST="router"
	
	fi
	
	echo "Ping ${HOST}"
	
	ping -w 3 ${HOST}
	
}

FILE_SET="hosts"
DIR_ETC="etc"

case "$1" in
	conf)
		hosts_conf
		;;
	show)
		util_show
		;;
 	ping)
		hosts_ping "$2"
		;;
	*)
		echo "Use: $0 {conf|show|ping}"
		exit 1
		;;
esac
