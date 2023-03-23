#!/bin/sh
# Script Configure Ubuntu Desktop 22.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

apps_install()
{

	echo "Install Essencial Apps..."
	
	#apt -y install arc arj cabextract lhasa p7zip p7zip-full p7zip-rar rar unrar unace unzip xz-utils zip
	#apt -y install gnome-shell-extension-prefs
	#apt -y install ubuntu-restricted-extras
	#apt -y install gnome-tweaks
	#apt -y install stacer
	#apt -y install mc curl
	
	apt -y install imagemagick ristretto pavucontrol parole thunar mate-calc mousepad
	
}

scripts_install()
{
	
	update_file "wallpaper.png" "/usr/share/backgrounds" "images"
	
	update_file "stream_record.sh" "/usr/bin" "bin"
	update_file "change_brightness.sh" "/usr/bin" "bin"
	update_file "print_screen.sh" "/usr/bin" "bin"
	update_file "crack.sh" "/usr/bin" "bin"
	
	cp -fv config/bash_aliases ${FILE_BASH}
	
	chown -v ${USER}.${USER} ${FILE_BASH}
	
	pixmaps_files
	
}

pixmaps_files()
{
	
	APP_NAME="pixmaps"
	
	FILES_SET=(
		"tools.xpm"
		"thunar.xpm"
		"parole.xpm"
		"reboot.xpm"
		"logout.xpm"
		"office.xpm"
		"network.xpm"
		"mousepad.xpm"
		"shutdown.xpm"
		"mate-calc.xpm"
		"developer.xpm"
		"ristretto.xpm"
		"anonymous.xpm"
		"homeoffice.xpm"
		"multimedia.xpm"
		"print_screen.xpm"
	)
	
	update_files "Configure" "/usr/share/${APP_NAME}" "images/${APP_NAME}"
	
}

browsers_install()
{

	echo "Install Google Chrome..."
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
	cd /tmp && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && cd ..
	
	echo "Install Opera VPN..."
	echo "deb https://deb.opera.com/opera-stable/ stable non-free" | tee /etc/apt/sources.list.d/opera-stable.list
	cd /tmp && wget -q -O - https://deb.opera.com/archive.key | apt-key add - && cd ..
	
	apt update && apt -y install opera-stable google-chrome-stable
	
}

geany_install()
{
	
	geany_files
	
	install_app
	
	git clone https://github.com/${APP_NAME}/${APP_NAME}-themes.git
	
	cd ${APP_NAME}-themes
	./install.sh
	cd ..
	
	rm -rf ${APP_NAME}-themes
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
	
	rm -rf ${DIR_CONFIG}/${APP_NAME}/colorschemes
	cp -rf /root/.config/${APP_NAME}/colorschemes ${DIR_CONFIG}/${APP_NAME}
	chown -v ${USER}.${USER} ${DIR_CONFIG}/${APP_NAME}/colorschemes
	
}

geany_files()
{
	
	APP_NAME="geany"
	
	FILES_SET=(
		"${APP_NAME}.conf"
		"keybindings.conf"
	)
	
}

audacious_install()
{
	
	audacious_files_config
	
	install_app
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
	
	audacious_files_playlist
	
	update_files "Configure" "${DIR_CONFIG}/${APP_NAME}/playlists" "config/${APP_NAME}/playlists"
			
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

streamtuner_install()
{

	streamtuner_files
	
	install_app "streamripper"
	
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

transmission_install()
{
	
	transmission_file
	
	install_app
	
	echo "Configure ${APP_NAME}..."
	
	DIR_ETC="/etc/${APP_NAME}"
	
	service ${APP_NAME} stop
	
	USER_TRANSMISISON="debian-transmission"
	
	if [ ! -f "${DIR_ETC}/${FILE_SET}.bak" ]; then
	
		cp -fv ${DIR_ETC}/${FILE_SET} ${DIR_ETC}/${FILE_SET}.bak
		
		usermod -a -G ${USER_TRANSMISISON} ${USER}
	
	fi
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc/${APP_NAME}"
	
	chown -v ${USER_TRANSMISISON}.${USER_TRANSMISISON} ${DIR_ETC}/${FILE_SET}
	
	DIR_TRANSMISSION="/home/torrents"
	
	if [ ! -d "${DIR_TRANSMISSION}" ]; then
	
		mkdir -pv ${DIR_TRANSMISSION}/.incomplete
	
	fi
	
	chown -Rv ${USER_TRANSMISISON}.${USER_TRANSMISISON} ${DIR_TRANSMISSION}
	
	systemctl disable ${APP_NAME}.service
	
	service ${APP_NAME} start
	service ${APP_NAME} status
	
}

transmission_file()
{
	
	APP_NAME="transmission-daemon"
	
	FILE_SET="settings.json"
	
}

fluxbox_install()
{
	
	fluxbox_files
	
	install_app
	
	update_files "Configure" "${DIR_FLUXBOX}" "config/${APP_NAME}"
	
	gtk_install
	
}

fluxbox_files()
{
	
	APP_NAME="fluxbox"
	
	DIR_FLUXBOX="/home/${USER}/.${APP_NAME}"
	
	FILES_SET=(
		"apps"
		"menu"
		"keys"
		"init"
		"startup"
	)
	
}

gtk_install()
{
	
	gtk_file
	
	update_file "${FILE_SET}" "${DIR_CONFIG}/${APP_NAME}" "config/${APP_NAME}"
	
	cp -fv config/gtkrc-2.0 ${FILE_GTK}
	
	chown -v ${USER}.${USER} ${FILE_GTK}
	
}

gtk_file()
{
	
	APP_NAME="gtk-3.0"
	
	FILE_SET="settings.ini"
	
	FILE_GTK="/home/${USER}/.gtkrc-2.0"
	
}

lightdm_install()
{
	
	APP_NAME="lightdm"
	
	install_app
	
	echo "Configure ${APP_NAME}..."
	
	dpkg-reconfigure lightdm
	
	cat /etc/X11/default-display-manager
	
}

desktop_backup()
{

	cp -fv ${FILE_BASH} config/bash_aliases
	
	geany_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	audacious_files_config
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	audacious_files_playlist
	
	update_files "Backup" "config/${APP_NAME}/playlists" "${DIR_CONFIG}/${APP_NAME}/playlists"
	
	streamtuner_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	transmission_file
	
	echo "Backup ${APP_NAME}..."
	
	update_file "${FILE_SET}" "etc/${APP_NAME}" "/etc/${APP_NAME}"
	
	fluxbox_files
	
	update_files "Backup" "config/${APP_NAME}" "${DIR_FLUXBOX}"
	
	gtk_file
	
	echo "Backup ${APP_NAME}..."
	
	update_file "${FILE_SET}" "config/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	cp -fv ${FILE_GTK} config/gtkrc-2.0
	
}

update_files()
{

	MSG_TXT="$1"

	DIR_UPDATE="$2"
	DIR_SOURCE="$3"

	echo "${MSG_TXT} ${APP_NAME}..."

	for FILE_SET in "${FILES_SET[@]}"
	do
		
		update_file "${FILE_SET}" "${DIR_UPDATE}" "${DIR_SOURCE}"
			
	done
	
}

update_file()
{

	FILE_CONF="$1"
	
	DIR_APP="$2"
	DIR_CLOUD="$3"
	
	if [ ! -d ${DIR_APP} ]; then
	
		mkdir -pv ${DIR_APP}
		chown -v ${USER}.${USER} ${DIR_APP}
	
	fi
	
	echo "Copy ${FILE_CONF} configuration..."
	
	rm -fv ${DIR_APP}/${FILE_CONF}
	
	cp -fv ${DIR_CLOUD}/${FILE_CONF} ${DIR_APP}
	
	chown -v ${USER}.${USER} ${DIR_APP}/${FILE_CONF}
	
}

install_app()
{
	
	echo "Install ${APP_NAME}..."
	apt -y install ${APP_NAME} "$1"
	
}

if [ `id -u` -ne 0 ]; then
	echo "Run script as root"
	exit 1
fi

USER=`git config user.name`

if [ -z "${USER}" ]; then
		
	echo "Not found a user name!"
	echo "Use: git_conf.sh name {NAME}"
	exit 1
	
fi

DIR_CONFIG="/home/${USER}/.config"

FILE_BASH="/home/${USER}/.bash_aliases"

case "$1" in
	install)
		apps_install
		;;
	scripts)
		scripts_install
		;;
	browsers)
		browsers_install
		;;
	geany)
		geany_install
		;;
	audacious)
		audacious_install
		;;
	streamtuner)
		streamtuner_install
		;;
	transmission)
		transmission_install
		;;
	fluxbox)
		fluxbox_install
		;;
	gtk)
		gtk_install
		;;
	lightdm)
		lightdm_install
		;;
	backup)
		desktop_backup
		;;
	all)
		apps_install
		scripts_install
		browsers_install
		geany_install
		audacious_install
		streamtuner_install
		transmission_install
		fluxbox_install
		gtk_install
		lightdm_install
		;;
	*)
		echo "Use: $0 {all|install|scripts|browsers|geany|audacious|streamtuner|transmission|fluxbox|gtk|lightdm|backup}"
		exit 1
		;;
esac
