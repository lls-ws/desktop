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
	
}

NAME_APP="ytmusic"

case "$1" in
	install)
		ytmusic_install
		;;
	release)
		ytmusic_release
		;;
  	all)
  		ytmusic_install
  		ytmusic_release
  		;;
	*)
		echo "Use: $0 {all|install|release}"
		exit 1
		;;
esac
