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

	apt update
 	
 	apt -y upgrade
  	
  	apt -y autoremove

   	echo "Disable APT News"
	sudo dpkg-divert --divert /etc/apt/apt.conf.d/20apt-esm-hook.conf.bak --rename --local /etc/apt/apt.conf.d/20apt-esm-hook.conf
	
	ls /etc/apt/apt.conf.d
	
}

install_google() {

	URL_DEB="https://dl.google.com/linux/direct"
	
 	FILE_DEB="google-chrome-stable_current_amd64.deb"
 	
	wget ${URL_DEB}/${FILE_DEB}
	
	apt -y install chromium-browser
	
	dpkg -i ${FILE_DEB}
	
 	rm -fv ${FILE_DEB}
	
 	chromium --version
  	
 	google-chrome --version
	
}

install_apps() {
	
 	apt -y install xterm geany fluxbox
	
	xterm -version
  	geany --version
  	fluxbox --version
  	
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
	apps)
		install_apps
		;;
  	all)
		update_apps
  		intel_driver
  		install_google
    	install_apps
		;;
	*)
		echo "Use: $0 {all|update|google|intel|apps}"
		exit 1
		;;
esac
