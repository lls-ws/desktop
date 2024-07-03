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

install_google() {
	
	DIR_LIST="/etc/apt/sources.list.d"
	
	FILE_LIST="${DIR_LIST}/google-chrome.list"
	
	delete_file
	
	echo "Add Google Chrome to sources.list.d"
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --yes --dearmour -o /usr/share/keyrings/google_linux_signing_key.gpg
	sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google_linux_signing_key.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > '${FILE_LIST}''
	
	show_file
	
 	update_apps
	
 	apt -y install google-chrome-stable

  	google-chrome --version
	
}

intel_driver() {
 	
	apt-get -y purge --auto-remove mesa-vulkan-drivers
  	
  	apt -y install vainfo
	
  	lspci -k | grep i915
  	
    	echo "LIBVA_DRIVER_NAME=i965" >> /etc/environment
	
     	cat /etc/environment
	
	export LIBVA_DRIVER_NAME=i965
 	
     	vainfo
	
      	echo "Type: reboot"
	
}

update_apps() {

	apt update && sudo apt -y upgrade

}

install_geany() {
	
 	apt -y install geany
  	
}

case "$1" in
  	update)
		update_apps
		;;
  	intel)
		intel_driver
		;;
	google)
		install_google
		;;
	geany)
		install_geany
		;;
  	all)
		update_apps
  		intel_driver
  		install_google
    		install_geany
		;;
	*)
		echo "Use: $0 {all|update|google|intel|geany}"
		exit 1
		;;
esac
