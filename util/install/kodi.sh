#!/bin/sh
# Script to Install and Configure Kodi on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

kodi_install()
{
	
	apt -y install --install-recommends --install-suggests ${NAME_APP}
	
	kodi_conf
	
}

kodi_conf()
{
	
	kodi_version
	
}

kodi_version()
{

	${NAME_APP} --version
	
}

kodi_uninstall()
{

	clear
	
	apt -y remove --purge --auto-remove ${NAME_APP}
	
}

NAME_APP="kodi"

case "$1" in
	install)
		kodi_install
		;;
	version)
		kodi_version
		;;
	conf)
		kodi_conf
		;;
	uninstall)
		kodi_uninstall
		;;
	*)
		echo "Use: $0 {install|version|conf|uninstall}"
		exit 1
		;;
esac
