#!/bin/sh
# Script to Install and Configure Firefox on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

firefox_release()
{
	
	URL_RELEASE="https://product-details.mozilla.org/1.0/firefox_versions.json"
	
	wget -O ${NAME_APP}.json ${URL_RELEASE}
	
	VERSION_FILE=`cat ${NAME_APP}.json | grep "LATEST_FIREFOX_VERSION" | cut -d ':' -f 2 | cut -d '"' -f 2 | cut -d '"' -f 1`
	
	rm -fv ${NAME_APP}.json
	
	echo "Release: ${VERSION_FILE}"
	
}

firefox_install()
{

	firefox_release
	
	snap remove ${NAME_APP}
 	
	URL_TAR="https://download-installer.cdn.mozilla.net/pub/${NAME_APP}/releases/${VERSION_FILE}/linux-x86_64/pt-BR"
 	
 	FILE_TAR="${NAME_APP}-${VERSION_FILE}.tar.xz"
 	
 	wget -O /opt/${FILE_TAR} ${URL_TAR}/${FILE_TAR}
 	
	rm -fv /usr/local/bin/${NAME_APP}
	rm -fv /usr/local/share/applications/${NAME_APP}.desktop
	
	cd /opt
	
	tar xfv ${FILE_TAR}
	
	if [ -d "/opt/${NAME_APP}" ]; then
		
		ln -s /opt/${NAME_APP}/${NAME_APP} /usr/local/bin/${NAME_APP}
		
		rm -fv ${FILE_TAR}
		
	fi
 	
 	cd -
		
 	firefox_version
	
}

firefox_version()
{

	VERSION_FILE=`${NAME_APP} --version`
	
	echo "Version: ${VERSION_FILE}"
	
}

NAME_APP="firefox"

case "$1" in
	install)
		firefox_install
		;;
	version)
		firefox_version
		;;
	release)
		firefox_release
		;;
  	all)
  		firefox_install
  		firefox_version
  		firefox_release
  		;;
	*)
		echo "Use: $0 {all|install|release|version}"
		exit 1
		;;
esac
