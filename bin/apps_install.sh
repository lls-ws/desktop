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
	
	apt -y install ./${FILE_DEB}
	
 	rm -fv ${FILE_DEB}
  	
 	google-chrome --version
	
}

install_apps() {
	
 	apt -y install xterm blueman fluxbox audacious pkg-config
	
	xterm -version
  	fluxbox --version
   	audacious --version
  	
}

install_geany()
{
	
	APP_NAME="geany"
 
	wget https://download.geany.org/${APP_NAME}-2.0.tar.gz

 	tar xvf ${APP_NAME}-2.0.tar.gz
	
	cd ${APP_NAME}-2.0
	./configure
 	make
  	make install
	cd ..
	
	rm -rf ${APP_NAME}-2.0.tar.gz

 	ibus-daemon --xim -d -r

 	${APP_NAME} --version
	
}

install_anydesk()
{
	
	curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/anydesk.gpg
	
 	echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
	
  	apt update
	
 	apt -y install anydesk
	
}

case "$1" in
  	update)
		update_apps
		;;
  	profile)
		set_profile
		;;
   	intel)
		intel_driver
		;;
	apps)
		install_apps
		;;
  	google)
		install_google
		;;
  	geany)
		install_geany
		;;
  	anydesk)
		install_anydesk
		;;
  	all)
		update_apps
  		set_profile
  		intel_driver
  		install_apps
    		install_google
    		install_geany
      		install_anydesk
		;;
	*)
		echo "Use: $0 {all|update|profile|intel|apps|google|geany|anydesk}"
		exit 1
		;;
esac
