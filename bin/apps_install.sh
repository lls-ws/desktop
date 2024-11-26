#!/bin/sh
# Script to install apps on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

delete_file()
{
	
	if [ -f ${FILE_LIST} ]; then

		rm -fv ${FILE_LIST}

	fi
	
}

show_file()
{
	
	cat ${FILE_LIST}
	
	ls /etc/apt/sources.list.d /usr/share/keyrings
	
}

intel_driver()
{
 	
	apt-get -y purge --auto-remove mesa-vulkan-drivers
  	
  	apt -y install vainfo
	
  	lspci -k | grep i915
  	
	echo "LIBVA_DRIVER_NAME=i965" >> /etc/environment

	cat /etc/environment
	
	export LIBVA_DRIVER_NAME=i965
 	
	vainfo

	echo "Type: reboot"
	
}

install_google()
{

	URL_DEB="https://dl.google.com/linux/direct"
	
 	FILE_DEB="google-chrome-stable_current_amd64.deb"
 	
	wget ${URL_DEB}/${FILE_DEB}
	
	apt -y install ./${FILE_DEB}
	
 	rm -fv ${FILE_DEB}
  	
  	echo "Set Google to default mailto"
  	xdg-settings set default-url-scheme-handler mailto google-chrome.desktop
  	xdg-settings get default-url-scheme-handler mailto
  	
  	echo "Set Google to default mailto"
  	xdg-mime default google-chrome.desktop x-scheme-handler/whatsapp
  	xdg-mime query default x-scheme-handler/whatsapp
  	
 	google-chrome --version
	
}

install_apps()
{
	
	apt -y install \
		transmission-common \
		transmission-daemon \
		nfs-kernel-server \
		transmission-cli \
		streamtuner2 \
		audacious \
  		wavemon \
		geany \
		kodi
	
	kodi --version
	geany --version
        wavemon -v
	audacious --version
	transmission-cli --version
	transmission-daemon --version
  	
  	streamtuner2 -V
	
  	rpcinfo -p | grep nfs
  	
}

install_kvantum()
{
	
 	apt -y install kvantum
	
	kvantummanager --version
  	
}

install_anydesk()
{
	
	curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/anydesk.gpg
	
 	echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
	
  	apt update
	
 	apt -y install anydesk
	
}

install_virtualbox()
{
	
	apt -y install virtualbox virtualbox-guest-utils
	
	virtualbox --help
	
}

case "$1" in
   	intel)
		intel_driver
		;;
	apps)
		install_apps
		;;
  	google)
		install_google
		;;
  	anydesk)
		install_anydesk
		;;
	kvantum)
		install_kvantum
		;;
  	virtualbox)
		install_virtualbox
		;;
  	all)
  		install_apps
		install_google
		install_anydesk
		install_kvantum
		install_virtualbox
		;;
	*)
		echo "Use: $0 {all|intel|apps|google|anydesk|kvantum|virtualbox}"
		exit 1
		;;
esac
