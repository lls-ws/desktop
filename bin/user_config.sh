#!/bin/sh
# Script to set user apps preferences on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

aliases_conf()
{
	
	cp -fv config/bash_aliases ${FILE_BASH}
	
	echo "Load gnome-terminal profiles..."
	dconf load /org/gnome/terminal/legacy/profiles:/ < config/gnome-terminal-profiles.dconf
	
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
	
	xdg-mime default thunar.desktop inode/directory
	xdg-mime query default inode/directory
	
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

desktop_backup()
{

	cp -fv ${FILE_BASH} config/bash_aliases
	
	echo "Create gnome-terminal-profiles.dconf"
	dconf dump /org/gnome/terminal/legacy/profiles:/ > config/gnome-terminal-profiles.dconf
	
	geany_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	audacious_files_config
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	audacious_files_playlist
	
	update_files "Backup" "config/${APP_NAME}/playlists" "${DIR_CONFIG}/${APP_NAME}/playlists"
	
	streamtuner_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	fluxbox_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_FLUXBOX}"
	
	gtk_files
	
	echo -e "\nBackup ${APP_NAME}..."
	
	update_file "${FILE_SET}" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	cp -fv ${FILE_GTK} config/gtkrc-2.0
	
}

USER=$(whoami)

if [ ${USER} = "root" ]; then
    
    echo "Root user not permited!"
    
    exit 1;
    
fi

DIR_CONFIG=~/.config

FILE_BASH=~/.bash_aliases

case "$1" in
	gtk)
		gtk_conf
		;;
	geany)
		geany_conf
		;;
	fluxbox)
		fluxbox_conf
		;;
	aliases)
		aliases_conf
		;;
	audacious)
		audacious_conf
		;;
	streamtuner)
		streamtuner_conf
		;;
	backup)
		desktop_backup
		;;
	all)
		gtk_conf
		geany_conf
		fluxbox_conf
		audacious_conf
		streamtuner_conf
		;;
	*)
		echo "Use: $0 {all|gtk|geany|fluxbox|aliases|audacious|streamtuner|backup}"
		exit 1
		;;
esac
