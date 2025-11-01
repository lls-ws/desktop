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

virtualbox_share()
{
	
	VBoxManage sharedfolder add "Windows 11" --name Apps --hostpath ".VirtualBox/Apps/" --automount
	
}

iphone_files()
{
	
	FILE_APP="3uTools_v3.18.006_Setup_x86.exe"
	
	if [ ! -f ${DIR_VBOX}/${FILE_APP} ]; then
	
		echo "Get ${FILE_APP}"
		sudo wget https://dl.3u.com/update/v300/dl/${FILE_APP} -P ${DIR_VBOX}
		
	fi
	
	FILE_APP="iPhone14,5_18.1_22B83_Restore.ipsw"
	
	if [ ! -f "${DIR_VBOX}/${FILE_APP}" ]; then
	
		echo "Get ${FILE_APP}"
		sudo wget "https://updates.cdn-apple.com/2024FallFCS/fullrestores/072-12507/B8C10ED2-240E-431B-940D-7F954247A17F/${FILE_APP}" -P ${DIR_VBOX}
		
	fi
	
	FILE_APP="Apple+Driver+Usb.rar"
	
	if [ ! -f ${DIR_VBOX}/${FILE_APP} ]; then
	
		echo "Get ${FILE_APP}"
		wget https://download2279.mediafire.com/f2l6imwg06pgsemjBK_6GmPM-emy9KfmlAIE8KbrI2bd39SPrq2jtvyZMdf-G9kQB97dqh_laJqE8y0CkYydknHdNTxBxkfNnZeeWN9KeZ0ULWCSGmq2PRILTzXXdruljKp8mpCzZmlVZoXXVM0U15QP3KscDXRKPTuO-W4zcdEgGz65/ji11c4bq22nxvzz/${FILE_APP} -P ${DIR_VBOX}
		
		if [ -f ${DIR_VBOX}/${FILE_APP} ]; then
	
			echo "Extract ${FILE_APP}"
			unrar x ${DIR_VBOX}/${FILE_APP} ${DIR_VBOX}
			
		fi
		
	fi
	
	echo "Showing iPhone files:"
	du -hsc ${DIR_VBOX}/*
	
}

virtualbox_files()
{
	
	FILE_APP="Windows_11_Torrent.txt"
	
	echo "Windows 11 Pro English x64 BiT Activated.iso" > ${DIR_VBOX}/${FILE_APP}
	echo -e "\nTorrent:" >> ${DIR_VBOX}/${FILE_APP}
	echo -e '\nmagnet:?xt=urn:btih:B47FB2B675F08A14D1A8023561503C623487A57A&dn=Windows%2011%20Pro%20English%20x64%20BiT%20Activated&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.bittor.pw%3A1337%2Fannounce&tr=udp%3A%2F%2Fpublic.popcorn-tracker.org%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fexodus.desync.com%3A6969&tr=udp%3A%2F%2Fopen.demonii.com%3A1337%2Fannounce' >> ${DIR_VBOX}/${FILE_APP}
	
	FILE_APP="VBoxGuestAdditions_7.1.4.iso"
	
	DIR_ISO="/mnt/shared/iso"
	
	if [ ! -f ${DIR_ISO}/${FILE_APP} ]; then
	
		echo "Get ${FILE_APP}"
		sudo wget https://download.virtualbox.org/virtualbox/7.1.4/${FILE_APP} -P ${DIR_ISO}
	
	fi

	sudo chown -v ${USER}:${USER} ${DIR_ISO}/${FILE_APP}
 
	FILE_APP="Windows-Activator.zip"
	
	if [ ! -f ${DIR_VBOX}/${FILE_APP} ]; then
	
		echo "Get ${FILE_APP}"
		wget https://github.com/Whitecat18/Windows-Activator/archive/refs/heads/main.zip -O ${DIR_VBOX}/${FILE_APP}
		
		if [ -f ${DIR_VBOX}/${FILE_APP} ]; then
	
			echo "Extract ${FILE_APP}"
			unzip ${DIR_VBOX}/${FILE_APP} -d ${DIR_VBOX}
			
		fi
		
	fi
	
	FILE_APP="ChromeSetup.exe"
	
	if [ ! -f ${DIR_VBOX}/${FILE_APP} ]; then
	
		echo "Get ${FILE_APP}"
		wget https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BB3519AA4-D6F8-8D32-22EC-47EDC730EBBE%7D%26lang%3Den%26browser%3D5%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-statsdef_1%26brand%3DUEAD%26installdataindex%3Dempty/update2/installers/${FILE_APP} -P ${DIR_VBOX}
	
	fi
	
}

virtualbox_conf()
{
	
	USER=`sudo git config user.name`
	
	echo "User: ${USER}"
	
	if [ -z "${USER}" ]; then
		
		echo "User not found!"
		exit;
	
	fi

	if [ ! -d ${DIR_VBOX} ]; then
		
		echo "Create VirtualBox Apps directory"
		mkdir -pv ${DIR_VBOX}

	fi
	
	echo "Add user ${USER} to group vboxusers from USB access"
	sudo adduser ${USER} vboxusers
	
	echo "Add user ${USER} to group vboxsf from Shared Folder access"
	sudo usermod -aG vboxsf ${USER}
	
	virtualbox_files
	
	echo "Showing files:"
	du -hsc ${DIR_ISO}/* ${DIR_VBOX}/* 
	
}

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
	
	echo "Pressione uma tecla para fechar!"
	read -t 3 -p "Aguardando..."
	killall qterminal
	
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
DIR_VBOX=~/.VirtualBox/Apps

case "$1" in
	kodi)
		kodi_conf
		;;
	lxqt)
		lxqt_conf
		;;
	geany)
		geany_conf
		;;
	iphone)
		iphone_files
		;;
	kvantum)
		kvantum_conf
		;;
	openbox)
		openbox_conf
		;;
	aliases)
		aliases_conf
		;;
	autostart)
		autostart_conf
		;;
	audacious)
		audacious_conf
		;;
	virtualbox)
		virtualbox_conf
		;;
	streamtuner)
		streamtuner_conf
		;;
	screensaver)
		screensaver_conf
		;;
	backup)
		desktop_backup
		;;
	all)
		kodi_conf
		lxqt_conf
		geany_conf
		iphone_files
		kvantum_conf
		openbox_conf
		aliases_conf
		autostart_conf
		audacious_conf
		virtualbox_conf
		streamtuner_conf
		screensaver_conf
		;;
	*)
		echo "Use: $0 {all|kodi|lxqt|geany|iphone|kvantum|openbox|aliases|autostart|audacious|virtualbox|streamtuner|screensaver|backup}"
		exit 1
		;;
esac
