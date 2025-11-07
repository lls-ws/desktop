#!/bin/sh
# Script to Disable Services on Lubuntu Desktop Start
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

clear

check_root "$1"

services_disable()
{

	for SERVICE in "${SERVICES[@]}"
	do
		
		sudo systemctl stop "${SERVICE}.service"
		
		sudo systemctl disable "${SERVICE}.service"
		
	done
	
	services_list
	
}

services_show()
{
	
	service --status-all
	
}

services_load()
{
	
	systemctl -t service --state=active
	
}

services_boot()
{
	
	systemctl list-unit-files --state=enabled
	
}

services_list()
{
	
	ls /etc/systemd/system/multi-user.target.wants
	
}

SERVICES=(
	"transmission-daemon"
	"cups-browsed"
	"teamviewerd"
	"anydesk"
	"openvpn"
	"tomcat9"
	"mariadb"
	"cups"
	"cron"
	"ssh"
)

case "$1" in
	disable)
		services_disable
		;;
	show)
		services_show
		;;
	load)
		services_load
		;;
	boot)
		services_boot
		;;
	list)
		services_list
		;;
	all)
		services_disable
		services_show
		services_load
		services_boot
		;;
	*)
		echo "Use: $0 {disable|show|load|boot|list}"
		exit 1
		;;
esac
