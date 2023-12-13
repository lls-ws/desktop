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

install_teamviewer() {
	
	cd /tmp && wget -c https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && sudo apt -y install ./teamviewer*.deb && cd ..
	
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

add_opera() {

	FILE_LIST="${DIR_LIST}/opera-stable.list"

	delete_file

	echo "Add Opera VPN to sources.list.d"
	wget -qO- https://deb.opera.com/archive.key | gpg --dearmor | sudo dd of=/usr/share/keyrings/opera-browser.gpg
	sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/opera-browser.gpg] https://deb.opera.com/opera-stable/ stable non-free" > '${FILE_LIST}''

	show_file

}

install_apps() {
	
	add_google
	
	add_opera
	
	update_apps

	apt -y install \
		kodi-inputstream-ffmpegdirect \
		kodi-inputstream-adaptive \
		google-chrome-stable \
		kodi-pvr-iptvsimple \
		transmission-daemon \
		nfs-kernel-server \
		opera-stable \
		streamtuner2 \
		streamripper \
		imagemagick \
		pavucontrol \
		ristretto \
		mate-calc \
		audacious \
		mousepad \
		fluxbox \
		lightdm \
		thunar \
		xterm \
		geany \
		curl \
		kodi \
		vlc \
		ssh
		
	install_teamviewer

}

update_apps() {
	
	sudo apt update
	
	sudo apt --only-upgrade -y install ghostscript-x python3-update-manager
	
	sudo dpkg-divert --divert /etc/apt/apt.conf.d/20apt-esm-hook.conf.bak --rename --local /etc/apt/apt.conf.d/20apt-esm-hook.conf
	
	ls /etc/apt/apt.conf.d
	
}

case "$1" in
	all)
		install_apps
		;;
	update)
		update_apps
		;;
	google)
		add_google
		;;
	opera)
		add_opera
		;;
	teamviewer)
		install_teamviewer
		;;
	*)
		echo "Use: $0 {all|update|google|opera|teamviewer}"
		exit 1
		;;
esac
