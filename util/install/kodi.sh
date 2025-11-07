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
		
		#nodejs npm
	
	${APP_NAME}_conf
	
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
	
	clear

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
	
	#echo "Node version: " `node -v`
    #echo "npm version: " `npm -v`
	
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
	
	cat ~/.${APP_NAME}/temp/${APP_NAME}.log | grep error
	
}

playlist_pluto()
{
	
	FILE_OPT="Filmes"
	
	FILE_FAV="pluto-favorites"
	
	FILE_LIST="playlist.m3u8"
	
	echo "Get ${FILE_LIST}"
	npx pluto-iptv
	
	echo "# Filmes" > ${FILE_FAV}
	
	echo "Get ${FILE_OPT} channels"
	cat ${FILE_LIST} | grep ${FILE_OPT} | cut -d '"' -f 2 >> ${FILE_FAV}
	
	rm -fv ${FILE_LIST}
	
	playlist_fav
	
}

playlist_fav()
{
	
	cat ${FILE_FAV}
	
	echo "Create ${FILE_LIST}"
	npx pluto-iptv
	
	FILE_EPG="epg.xml"
	
	sed -i 's/#EXTM3U/#EXTM3U x-tvg-url="'${FILE_EPG}'"/g' ${FILE_LIST}
	
	DIR_LIST="config/${APP_NAME}/userdata/playlists/video"
	
	rm -fv cache.json
	
	mv -fv ${FILE_FAV} ${FILE_EPG} ${FILE_LIST} ${DIR_LIST}
	
	ls -al ${DIR_LIST}
	
}

flatpak_install()
{
	
	sudo apt install flatpak
	
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	
	flatpak install flathub com.stremio.Stremio
	
	flatpak run com.stremio.Stremio
	
	flatpak uninstall --delete-data stremio
	
	flatpak uninstall --unused
	
	flatpak update
	
}

iptvnator_install()
{
	
	sudo snap install iptvnator
	
	sudo snap remove iptvnator
	
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
		clear
		kodi_conf
		;;
	backup)
		kodi_backup
		;;
	log)
		kodi_log
		;;
	playlist)
		playlist_pluto
		;;
	uninstall)
		kodi_uninstall
		;;
	*)
		echo "Use: $0 {install|version|conf|backup|log|playlist|uninstall}"
		exit 1
		;;
esac
