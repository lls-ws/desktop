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

aliases_conf()
{
	
	cp -fv config/bash_aliases ${FILE_BASH}
	
	FILE_ALIASES=~/.zshrc
	
	if [ -f ${FILE_ALIASES} ]; then
	
		echo "if [ -f ~/.bash_aliases ]; then"		>> ${FILE_ALIASES}
		echo "   . ~/.bash_aliases"			>> ${FILE_ALIASES}
		echo "fi"					>> ${FILE_ALIASES}
		
		cat ${FILE_ALIASES} | tail -3
	
	else
	
		echo "Load gnome-terminal profiles..."
		dconf load /org/gnome/terminal/legacy/profiles:/ < config/gnome-terminal-profiles.dconf
		
	fi
	
}

gtk_files()
{
	
	FILE_GTK=~/.gtkrc-2.0
	
}

gtk_conf()
{
	
	gtk_files
	
	cp -fv config/gtkrc-2.0 ${FILE_GTK}
	
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
	gsettings range org.gnome.desktop.interface color-scheme
	
	xdg-mime default thunar.desktop inode/directory
	xdg-mime query default inode/directory
	
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
 	
	gtk_files
	
	echo -e "\nBackup ${APP_NAME}..."
	
	update_file "${FILE_SET}" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	cp -fv ${FILE_GTK} config/gtkrc-2.0
	
}

DIR_CONFIG=~/.config

FILE_BASH=~/.bash_aliases

case "$1" in
	gtk)
		gtk_conf
		;;
	kodi)
		kodi_conf
		;;
	geany)
		geany_conf
		;;
	aliases)
		aliases_conf
		;;
	backup)
		desktop_backup
		;;
	all)
		gtk_conf
		kodi_conf
		geany_conf
		aliases_conf
		;;
	*)
		echo "Use: $0 {all|gtk|kodi|geany|aliases|backup}"
		exit 1
		;;
esac
