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
	
   	grep VERSION /etc/os-release
        uname -v
        uname -r
	
}

set_profile()
{
	
	echo "Showing locale..."
	locale
	
	echo "Setting pt_BR..."
	dpkg-reconfigure locales
	
	echo "Changing profile to pt_BR..."
	update-locale LC_ALL=pt_BR.UTF-8 LANG=pt_BR.UTF-8 LANGUAGE=pt_BR
	
	echo "Changing timezone..."
	timedatectl set-timezone America/Sao_Paulo
	
	echo "Showing new locale and new date..."
	cat /etc/default/locale
	date
	
}

install_google() {

	URL_DEB="https://dl.google.com/linux/direct"
	
 	FILE_DEB="google-chrome-stable_current_amd64.deb"
 	
	wget ${URL_DEB}/${FILE_DEB}
	
	apt -y install libu2f-udev ./${FILE_DEB}
	
 	rm -fv ${FILE_DEB}
  	
 	google-chrome --version
	
}

install_apps() {
	
 	apt -y install xterm geany fluxbox audacious
	
	xterm -version
  	geany --version
  	fluxbox --version
   	audacious --version
  	
}

case "$1" in
  	update)
		update_apps
		;;
  	set_profile)
		profile
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
		echo "Use: $0 {all|update|profile|google|intel|apps}"
		exit 1
		;;
esac
