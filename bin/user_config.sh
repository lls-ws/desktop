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

lxqt_conf()
{
	
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

gtk_files()
{
	
	APP_NAME="gtk-3.0"
	
	FILE_SET="settings.ini"
	
	FILE_GTK=~/.gtkrc-2.0
	
}

gtk_conf()
{
	
	gtk_files
	
	update_file "${FILE_SET}" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
	
	cp -fv config/gtkrc-2.0 ${FILE_GTK}
	
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
	gsettings range org.gnome.desktop.interface color-scheme
	
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

fluxbox_files()
{
	
	APP_NAME="fluxbox"
	
	DIR_FLUXBOX=~/.${APP_NAME}
	
	FILES_SET=(
		"apps"
		"menu"
		"keys"
		"init"
		"startup"
	)
	
}

fluxbox_conf()
{
	
	fluxbox_files
	
	update_files "Configure" "${DIR_FLUXBOX}" "config/${APP_NAME}"
	
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

	geany_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
 	
 	fluxbox_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_FLUXBOX}"
 	
	gtk_files
	
	echo -e "\nBackup ${APP_NAME}..."
	
	update_file "${FILE_SET}" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	cp -fv ${FILE_GTK} config/gtkrc-2.0
	
}

DIR_CONFIG=~/.config

case "$1" in
	gtk)
		gtk_conf
		;;
	lxqt)
		lxqt_conf
		;;
	geany)
		geany_conf
		;;
	fluxbox)
		fluxbox_conf
		;;
  	audacious)
		audacious_conf
		;;
	aliases)
		aliases_conf
		;;
	backup)
		desktop_backup
		;;
	all)
		gtk_conf
		geany_conf
		aliases_conf
		;;
	*)
		echo "Use: $0 {all|gtk|lxqt|geany|audacious|fluxbox|aliases|backup}"
		exit 1
		;;
esac
