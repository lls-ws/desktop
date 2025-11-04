#!/bin/sh
# Script to Install and Configure Google Chrome on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

google_install()
{

	URL_DEB="https://dl.google.com/linux/direct"
	
 	FILE_DEB="${NAME_APP}-stable_current_amd64.deb"
 	
 	apt -y remove --purge ${NAME_APP}-stable
 	
 	remove_list "${NAME_APP}"
 	
 	install_deb
 	
	remove_list "${NAME_APP}"
	
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > ${DIR_LIST}/${FILE_LIST}.list
	
	cat ${DIR_LIST}/${FILE_LIST}.list
	
	google_config
	
 	google_version
	
}

google_config()
{
	
	echo "Set ${NAME_APP} to default mailto"
  	xdg-settings set default-url-scheme-handler mailto ${NAME_APP}.desktop
  	xdg-settings get default-url-scheme-handler mailto
  	
  	echo "Set ${NAME_APP} to default whatsapp"
  	xdg-mime default ${NAME_APP}.desktop x-scheme-handler/whatsapp
  	xdg-mime query default x-scheme-handler/whatsapp
  	
}

google_version()
{

	VERSION_FILE=`${NAME_APP} --version`
	
	echo "Version: ${VERSION_FILE}"
	
}

NAME_APP="google-chrome"

case "$1" in
	install)
		google_install
		;;
	config)
		google_config
		;;
  	version)
		google_version
		;;
	*)
		echo "Use: $0 {install|config|version}"
		exit 1
		;;
esac
