#!/bin/sh
# Script to Install and Configure YouTube Music on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

ytmusic_release()
{
	
	URL_RELEASE="https://github.com/ytmdesktop/ytmdesktop/releases/latest"
	
	wget -O ${NAME_APP}.html ${URL_RELEASE}
	
	VERSION_FILE=`cat ${NAME_APP}.html | grep -A 5 Releases | grep tag | rev | cut -d '"' -f 1 | rev | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -d 'v' -f 2`
	
	rm -fv ${NAME_APP}.html
	
	echo "Release: ${VERSION_FILE}"
	
}

ytmusic_install()
{

	ytmusic_release
	
	URL_DEB="https://github.com/ytmdesktop/ytmdesktop/releases/download/v${VERSION_FILE}"
	
 	FILE_DEB="youtube-music-desktop-app_${VERSION_FILE}_amd64.deb"
 	
	install_deb
	
	sudo apt -y install playerctl xdotool
	
	ytmusic_config
	
}

ytmusic_config()
{
	
	echo "Configure ${NAME_APP}..."
	
	USER=`git config user.name`
	
	echo "User: ${USER}"
	
	FILE_NAME="config.json"
	FILE_SOURCE='config/YouTube Music Desktop App'/${FILE_NAME}
	FILE_UPDATE='/home/'${USER}'/.'${FILE_SOURCE}
	
	if [ ! -z "${USER}" ]; then
	
		cp -fv "${FILE_SOURCE}" "${FILE_UPDATE}"
		
		chown -v lls:lls "${FILE_UPDATE}"
		
		cat "${FILE_UPDATE}" | grep -E "startMinimized|windowMaximized"
	
	fi
	
}

NAME_APP="ytmusic"

FILE_CONF="config.json"

DIR_ETC="config/YouTube\ Music\ Desktop\ App/"

case "$1" in
	install)
		ytmusic_install
		;;
	release)
		ytmusic_release
		;;
	config)
		ytmusic_config
		;;
	*)
		echo "Use: $0 {install|release|config}"
		exit 1
		;;
esac
