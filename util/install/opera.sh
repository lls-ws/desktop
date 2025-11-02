#!/bin/sh
# Script to Install and Configure Opera on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

opera_release()
{
	
	URL_RELEASE="https://download3.operacdn.com/ftp/pub/opera/desktop/"
	
	wget -O ${NAME_APP}.html ${URL_RELEASE}
	
	VERSION_FILE=`cat ${NAME_APP}.html | grep 2025 | sort | tail -1 | cut -d '"' -f 2 | cut -d '/' -f 1`
	
	rm -fv ${NAME_APP}.html
	
	echo "Release: ${VERSION_FILE}"
	
}

opera_install()
{

	opera_release
	
	URL_DEB="https://download3.operacdn.com/ftp/pub/opera/desktop/${VERSION_FILE}/linux"
 	
 	FILE_DEB="${NAME_APP}_${VERSION_FILE}_amd64.deb"
 	
	apt -y remove --purge ${NAME_APP}
	
	remove_list "${NAME_APP}"
	
	install_deb
	
	cat ${DIR_LIST}/${FILE_LIST}.list
		
 	opera_version
	
}

opera_version()
{

	VERSION_FILE=`$(echo ${NAME_APP} | cut -d '-' -f 1) --version`
	
	echo "Version: ${VERSION_FILE}"
	
}

NAME_APP="opera-stable"

case "$1" in
	install)
		opera_install
		;;
	version)
		opera_version
		;;
	release)
		opera_release
		;;
  	all)
  		opera_install
  		opera_version
  		opera_release
  		;;
	*)
		echo "Use: $0 {all|install|release|version}"
		exit 1
		;;
esac
