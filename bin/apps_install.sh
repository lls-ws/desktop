#!/bin/sh
# Script to install apps on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

delete_file() {
	
	if [ -f ${FILE_LIST} ]; then

		rm -fv ${FILE_LIST}

	fi
	
}

show_file() {
	
	cat ${FILE_LIST}
	
	ls /etc/apt/sources.list.d /usr/share/keyrings
	
}

add_google() {
	
	DIR_LIST="/etc/apt/sources.list.d"
	
	FILE_LIST="${DIR_LIST}/google-chrome.list"
	
	delete_file
	
	echo "Add Google Chrome to sources.list.d"
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --yes --dearmour -o /usr/share/keyrings/google_linux_signing_key.gpg
	sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google_linux_signing_key.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > '${FILE_LIST}''
	
	show_file
	
}

install_apps() {
	
	apt update && sudo apt -y upgrade
	
 	apt -y install curl apt-transport-https gdebi
	
	URL_DEB="https://dl.google.com/linux/direct/"

 	# Version: 126.0.6478.126-1
 	FILE_DEB="google-chrome-stable_current_amd64.deb"
	
  	wget ${URL_DEB}/${FILE_DEB}
	
   	gdebi ${FILE_DEB}
	
    	rm -fv ${FILE_DEB}
  	
}

case "$1" in
	all)
		install_apps
		;;
	google)
		add_google
		;;
	*)
		echo "Use: $0 {all|google}"
		exit 1
		;;
esac
