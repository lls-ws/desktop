#!/bin/sh
# Script to configure Apps User Profile on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_user "$1"

config_update()
{

	set_app "${1}"
	
	update_files_dir
	
	apps_show "${1}"
	
}

APPS_CONF=(
	"vlc"
	"mpv"
	"geany"
	"openbox"
	"kvantum"
	"autostart"
)

if [[ " ${APPS_CONF[*]} " =~ " ${1} " ]]; then

	if [ -z "$2" ]; then
	
		config_update "${1}"
		
	else
	
		case "$2" in
			show)
				apps_show "${1}"
				;;
			*)
				echo "Use: $0 $1 show"
				exit 1
				;;
		esac
	
	fi
		
else

	case "$1" in
		all)
			for APP_CONF in "${APPS_CONF[@]}"
			do
				
				config_update "${APP_CONF}"
				
			done
			;;
		*)
			echo "Use: $0 [all ${APPS_CONF[@]}]"
			exit 1
			;;
	esac

fi
