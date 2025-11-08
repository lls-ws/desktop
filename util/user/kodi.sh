#!/bin/sh
# Script to Install and Configure Kodi on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_user "$1"

kodi_install()
{
	
	sudo apt -y install \
		${APP_NAME} \
		${APP_NAME}-pvr-iptvsimple \
		mplayer mpv x264
	
	${APP_NAME}_version
	
}

kodi_conf()
{
	
	echo "Copying ${APP_NAME} Files..."

	for DIR_NAME in "${DIR_NAMES[@]}"
	do
		
		echo -e "\nCopy: ${DIR_NAME}"
		
		DIR_SOURCE="config/${APP_NAME}/${DIR_NAME}"
		
		for FILE in ${DIR_SOURCE}/*; do
		
			FILE="$(basename "${FILE}")"
		
			DIR_UPDATE=~/.${APP_NAME}/${DIR_NAME}
			
			update_file ${FILE} ${DIR_UPDATE} ${DIR_SOURCE}
			
		done

		ls -al ${DIR_SOURCE}
			
	done
	
	echo -e "\nCopy ${APP_NAME} files done!"
	
}

kodi_backup()
{
	
	echo "Creating Backup ${APP_NAME} Files..."

	for DIR_NAME in "${DIR_NAMES[@]}"
	do
		
		echo -e "\nBackup: ${DIR_NAME}"
		
		DIR_UPDATE="config/${APP_NAME}/${DIR_NAME}"
		
		for FILE in ${DIR_UPDATE}/*; do
		
			FILE="$(basename "${FILE}")"
		
			DIR_SOURCE=~/.${APP_NAME}/${DIR_NAME}
			
			update_file ${FILE} ${DIR_UPDATE} ${DIR_SOURCE}
			
		done

		ls -al ${DIR_UPDATE}
			
	done
	
	echo -e "\nBackup ${APP_NAME} done!"
	
}

kodi_version()
{

	${APP_NAME} --version
	
	mplayer --version
	mpv --version
	x264 --version
	
}

kodi_uninstall()
{

	sudo apt -y remove --purge --auto-remove \
		${APP_NAME} \
		${APP_NAME}-pvr-iptvsimple \
		mplayer mpv x264
		
	echo "Deleting ${APP_NAME} files..."
	rm -rf ~/.${APP_NAME}
	
}

kodi_log()
{
	
	clear
	
	cat ~/.${APP_NAME}/temp/${APP_NAME}.log
	
}

APP_NAME="kodi"

DIR_NAMES=(
	"userdata"
	"userdata/addon_data/pvr.iptvsimple"
	"userdata/addon_data/weather.gismeteo"
	"media/Fonts"
)

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
	backup)
		kodi_backup
		;;
	log)
		kodi_log
		;;
	uninstall)
		kodi_uninstall
		;;
	all)
		kodi_install
		kodi_conf
		;;
	*)
		echo "Use: $0 {all|install|version|conf|backup|log|uninstall}"
		exit 1
		;;
esac
