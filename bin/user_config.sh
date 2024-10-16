#!/bin/sh
# Script to set user apps preferences on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_user "$1"

DIR_LLS=~/.lls-src

if [ ! -d ${DIR_LLS} ]; then
	
	mkdir -pv ${DIR_LLS}

fi

kodi_files()
{
	
	APP_NAME="kodi"
	
	DIR_KODI=~/.${APP_NAME}
	
	FILES_SET=(
		"sources.xml"
	)
	
}

kodi_conf()
{
	
	kodi_files
	
	update_files "Configure" "${DIR_KODI}/userdata" "config/${APP_NAME}"
	
}

autostart_files()
{
	
	APP_NAME="autostart"
	
	FILES_SET=(
		"Som.desktop"
		"Cursor.desktop"
		"YouTube.desktop"
		"Audacious.desktop"
	)
	
}

autostart_conf()
{
	
	autostart_files
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
		
}

openbox_files()
{
	
	APP_NAME="openbox"
	
	FILES_SET=(
		"rc.xml"
	)
	
}

openbox_conf()
{
	
	openbox_files
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
		
}

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
	
	kvantum_conf
	
}

kvantum_files()
{
	
	APP_NAME="lxqt"
	
	FILES_SET=(
		"session.conf"
	)
	
}

kvantum_conf()
{
	
	kvantum_files
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
	
	FILE_PROFILE=~/.profile
	
	sed -i '/kvantum/d' ${FILE_PROFILE}
	
	echo "export QT_STYLE_OVERRIDE=kvantum" >> ${FILE_PROFILE}
	
	cat ${FILE_PROFILE}
	
}

aliases_conf()
{
	
	FILE_ALIASES=~/.bash_aliases
	
	FILE_NAME="bash_aliases_desktop"
	
	FILE_CLOUD=~/.${FILE_NAME}
	
	rm -fv ${FILE_ALIASES}
	
	cp -fv util/${FILE_NAME} ${FILE_CLOUD}
	
	for FILE in ~/.bash_aliases_*; do
	
		echo ${FILE}
	
		echo ". ${FILE}" >> ${FILE_ALIASES}
		
	done
	
	cat ${FILE_CLOUD} ${FILE_ALIASES}
	
}

screensaver_files()
{
	
	FILE_SCR=~/.xscreensaver
	
}

screensaver_conf()
{
	
	screensaver_files
	
	cp -fv config/xscreensaver ${FILE_SCR}
	
	ls ${FILE_SCR}
	
}

geany_files()
{
	
	APP_NAME="geany"
	
	FILES_SET=(
		"${APP_NAME}.conf"
		"keybindings.conf"
	)
	
}

geany_conf()
{
	
	geany_files
	
	git clone https://github.com/${APP_NAME}/${APP_NAME}-themes.git
	
	cd ${APP_NAME}-themes
	./install.sh
	cd ..
	
	rm -rf ${APP_NAME}-themes
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
	
}

streamtuner_files()
{
	
	APP_NAME="streamtuner2"
	
	FILES_SET=(
		"settings.json"
		"bookmarks.json"
	)
	
}

streamtuner_conf()
{

	streamtuner_files
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
	
}

audacious_files_config()
{
	
	APP_NAME="audacious"
	
	FILES_SET=(
		"config"
		"plugin-registry"
		"playlist-state"
	)
	
}

audacious_files_playlist()
{
	
	FILES_SET=(
		"1000.audpl"
		"1001.audpl"
		"order"
	)
	
}

audacious_conf()
{
	
	audacious_files_config
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
	
	audacious_files_playlist
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}/playlists" "config/${APP_NAME}/playlists"
			
}

desktop_backup()
{

	## Autostart
	autostart_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	## Openbox
	openbox_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	## Lxqt
	lxqt_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	## Geany
	geany_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
 	
 	## Audacious
 	audacious_files_config
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	audacious_files_playlist
	
	update_files "Backup" "config/${APP_NAME}/playlists" "${DIR_CONFIG}/${APP_NAME}/playlists"
	
	## Streamtuner
	streamtuner_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
 	
 	## Xscreensaver
 	screensaver_files
 	
	cp -fv ${FILE_SCR} config/xscreensaver
	
	## Kodi
	kodi_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_KODI}/userdata"
	
	ls config
	
}

DIR_CONFIG=~/.config

case "$1" in
	kodi)
		kodi_conf
		;;
	lxqt)
		lxqt_conf
		;;
	kvantum)
		kvantum_conf
		;;
	geany)
		geany_conf
		;;
	openbox)
		openbox_conf
		;;
	autostart)
		autostart_conf
		;;
	audacious)
		audacious_conf
		;;
	streamtuner)
		streamtuner_conf
		;;
	screensaver)
		screensaver_conf
		;;
	aliases)
		aliases_conf
		;;
	backup)
		desktop_backup
		;;
	all)
		lxqt_conf
		geany_conf
		openbox_conf
		autostart_conf
		audacious_conf
		screensaver_conf
		aliases_conf
		;;
	*)
		echo "Use: $0 {all|kodi|lxqt|kvantum|geany|openbox|autostart|audacious|streamtuner|screensaver|aliases|backup}"
		exit 1
		;;
esac
