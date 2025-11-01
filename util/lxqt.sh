#!/bin/sh
# Script to Configure LXQT on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

clear

lxqt_files()
{
	
	APP_NAME="lxqt"
	
	FILES_SET=(
		"${APP_NAME}.conf"
		"panel.conf"
		"session.conf"
		"notifications.conf"
		"globalkeyshortcuts.conf"
		"lxqt-powermanagement.conf"
	)
	
}

lxqt_conf()
{
	
	lxqt_files
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
	
}

lxqt_menu()
{
	
	MENU_FILE="lxqt-lls.menu"
	
	DIR_MENU="etc/xdg/menus"
	
	update_file "${MENU_FILE}" "/${DIR_MENU}" "${DIR_MENU}"
	
}

case "$1" in
	menu)
		lxqt_menu
		;;
	all)
  		lxqt_menu
  		;;
	*)
		echo "Use: $0 {all|menu}"
		exit 1
		;;
esac
