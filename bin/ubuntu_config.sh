#!/bin/sh
# Script Configure Ubuntu Desktop 22.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

apps_install()
{

	echo "Install Essencial Apps..."
	apt -y install arc arj cabextract lhasa p7zip p7zip-full p7zip-rar rar unrar unace unzip xz-utils zip
	apt -y install gnome-shell-extension-prefs
	apt -y install ubuntu-restricted-extras
	apt -y install gnome-tweaks
	apt -y install stacer
	apt -y install mc curl
	
}

scripts_install()
{
	
	copy_file "stream_record.sh"
	
	update_file "wallpaper.png" "/usr/share/backgrounds" "images"
	update_file "wallpaper.png" "/home/${USER}/.local/share/backgrounds" "images"
	
	FILE_BASH="/home/${USER}/.bash_aliases"
	
	cp -fv conf/bash_aliases ${FILE_BASH}
	
	chown -v ${USER}.${USER} ${FILE_BASH}
	
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
	
	APP_NAME="geany"
	
	echo "Install ${APP_NAME}..."
	apt -y install ${APP_NAME}
	
	git clone https://github.com/${APP_NAME}/${APP_NAME}-themes.git
	
	cd ${APP_NAME}-themes
	./install.sh
	cd ..
	
	rm -rf ${APP_NAME}-themes
	
	rm -rf ${DIR_CONFIG}/${APP_NAME}/colorschemes
	cp -rf /root/.config/${APP_NAME}/colorschemes ${DIR_CONFIG}/${APP_NAME}
	chown -v ${USER}.${USER} ${DIR_CONFIG}/${APP_NAME}/colorschemes
	
	echo "Configure ${APP_NAME}..."
	
	update_file "${APP_NAME}.conf" "${DIR_CONFIG}/${APP_NAME}" "conf/${APP_NAME}"
	update_file "keybindings.conf" "${DIR_CONFIG}/${APP_NAME}" "conf/${APP_NAME}"
	
}

audacious_install()
{
	
	APP_NAME="audacious"
	
	echo "Install ${APP_NAME}..."
	apt -y install ${APP_NAME}
	
	echo "Configure ${APP_NAME}..."
	
	update_file "config" "${DIR_CONFIG}/${APP_NAME}" "conf/${APP_NAME}"
	update_file "plugin-registry" "${DIR_CONFIG}/${APP_NAME}" "conf/${APP_NAME}"
	update_file "playlist-state" "${DIR_CONFIG}/${APP_NAME}" "conf/${APP_NAME}"
	update_file "1000.audpl" "${DIR_CONFIG}/${APP_NAME}/playlists" "conf/${APP_NAME}/playlists"
	
}

streamtuner_install()
{

	APP_NAME="streamtuner2"
	
	echo "Install ${APP_NAME}..."
	apt -y install ${APP_NAME} streamripper
	
	echo "Configure ${APP_NAME}..."
	
	update_file "settings.json" "${DIR_CONFIG}/${APP_NAME}" "conf/${APP_NAME}"
	update_file "bookmarks.json" "${DIR_CONFIG}/${APP_NAME}" "conf/${APP_NAME}"
	
}

transmission_install()
{
	
	APP_NAME="transmission-daemon"
	
	echo "Install ${APP_NAME}..."
	apt -y install ${APP_NAME}
	
	echo "Configure ${APP_NAME}..."
	
	DIR_ETC="/etc/${APP_NAME}"
	
	FILE_SET="settings.json"
	
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

fluxbox_install()
{
	
	APP_NAME="fluxbox"
	
	echo "Install ${APP_NAME}..."
	apt -y install ${APP_NAME}
	
	echo "Configure ${APP_NAME}..."
	
	DIR_FLUXBOX="/home/${USER}/.${APP_NAME}"
	
	if [ ! -d "${DIR_FLUXBOX}" ]; then
	
		mkdir -v ${DIR_FLUXBOX}
		
		chown -v ${USER}.${USER} ${DIR_FLUXBOX}
	
	fi
	
	FILES_SET=(
		"apps"
		"menu"
		"keys"
		"init"
		"startup"
	)
	
	for FILE_SET in "${FILES_SET[@]}"
	do
		
		if [ -n "${FILE_SET}" ]; then
		
			if [ ! -f "${DIR_FLUXBOX}/${FILE_SET}.bak" ]; then
	
				cp -fv ${DIR_FLUXBOX}/${FILE_SET} ${DIR_FLUXBOX}/${FILE_SET}.bak
				
				chown -v ${USER}.${USER} ${DIR_FLUXBOX}/${FILE_SET}.bak
				
				#update_file "${FILE_SET}" "${DIR_FLUXBOX}" "conf/${APP_NAME}"
			
			fi
			
		fi
		
	done
	
}

lightdm_install()
{
	
	APP_NAME="lightdm"
	
	echo "Install ${APP_NAME}..."
	apt -y install ${APP_NAME}
	
	echo "Configure ${APP_NAME}..."
	
	dpkg-reconfigure lightdm
	
	cat /etc/X11/default-display-manager
	
}

desktop_backup()
{

	APP_NAME="geany"
	
	echo "Backup ${APP_NAME}..."
	
	update_file "${APP_NAME}.conf" "conf/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	update_file "keybindings.conf" "conf/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	APP_NAME="audacious"
	
	echo "Backup ${APP_NAME}..."
	
	update_file "config" "conf/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	update_file "plugin-registry" "conf/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	update_file "playlist-state" "conf/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	update_file "1000.audpl" "conf/${APP_NAME}/playlists" "${DIR_CONFIG}/${APP_NAME}/playlists"
	
	APP_NAME="streamtuner2"
	
	echo "Backup ${APP_NAME}..."
	
	update_file "settings.json" "conf/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	update_file "bookmarks.json" "conf/${APP_NAME}" "${DIR_CONFIG}/${APP_NAME}"
	
	APP_NAME="transmission-daemon"
	
	echo "Backup ${APP_NAME}..."
	
	update_file "settings.json" "etc/${APP_NAME}" "/etc/${APP_NAME}"
	
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
	
	echo "Copy File Configuration..."
	rm -fv ${DIR_APP}/${FILE_CONF}
	
	cp -fv ${DIR_CLOUD}/${FILE_CONF} ${DIR_APP}
	
	chown -v ${USER}.${USER} ${DIR_APP}/${FILE_CONF}
	
}

copy_file()
{
	
	FILE_SCRIPT="$1"
	
	DIR_BIN="/usr/bin"
	
	if [ ! -f "bin/${FILE_SCRIPT}" ]; then
	
		echo "File ${FILE_SCRIPT} not found!"
		exit 1
	
	fi
	
	if [ -f "${DIR_BIN}/${FILE_SCRIPT}" ]; then
	
		rm -fv ${DIR_BIN}/${FILE_SCRIPT}
	
	fi
	
	cp -fv bin/${FILE_SCRIPT} ${DIR_BIN}/${FILE_SCRIPT}
	
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
		;;
	*)
		echo "Use: $0 {all|install|scripts|browsers|geany|audacious|streamtuner|transmission|fluxbox|lightdm|backup}"
		exit 1
		;;
esac
