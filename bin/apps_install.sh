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

config_file()
{
	
	DIR_CHROME="/usr/share/applications"
	FILE_CONFIG="config/google-chrome/google-chrome.desktop"
	
	if [ -f ${FILE_CONFIG} ]; then
	
		cp -fv ${FILE_CONFIG} ${DIR_CHROME}
	
	fi
	
	echo "Set Google to default mailto"
  	xdg-settings set default-url-scheme-handler mailto google-chrome.desktop
  	xdg-settings get default-url-scheme-handler mailto
  	
  	echo "Set Google to default whatsapp"
  	xdg-mime default google-chrome.desktop x-scheme-handler/whatsapp
  	xdg-mime query default x-scheme-handler/whatsapp
  	
}

install_deb()
{
	
	wget ${URL_DEB}/${FILE_DEB}
	
	sudo apt -y install ./${FILE_DEB}
	
 	rm -fv ${FILE_DEB}
	
}

install_opera()
{
	
	opera_version
	
	URL_DEB="https://download3.operacdn.com/ftp/pub/opera/desktop/${VERSION_FILE}/linux"
 	
 	FILE_DEB="opera-stable_${VERSION_FILE}_amd64.deb"
 	
	apt -y remove --purge opera-stable
	
	remove_list "opera-stable"
	
	install_deb
	
	cat ${DIR_LIST}/${FILE_LIST}.list
	
	opera --version
	
}

remove_list()
{
	
	FILE_LIST="$1"
	
	DIR_LIST=/etc/apt/sources.list.d
	
	rm -fv ${DIR_LIST}/${FILE_LIST}.*
	
}

install_google()
{

	URL_DEB="https://dl.google.com/linux/direct"
	
 	FILE_DEB="google-chrome-stable_current_amd64.deb"
 	
 	apt -y remove --purge google-chrome-stable
 	
 	remove_list "google-chrome"
 	
 	install_deb
 	
	remove_list "google-chrome"
	
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > ${DIR_LIST}/${FILE_LIST}.list
	
	cat ${DIR_LIST}/${FILE_LIST}.list
	
	config_file
	
 	google-chrome --version
	
}

install_firefox()
{
	
	snap remove firefox
 	
 	firefox_version
	
	URL_TAR="https://download-installer.cdn.mozilla.net/pub/firefox/releases/${VERSION_FILE}/linux-x86_64/pt-BR"
 	
 	FILE_TAR="firefox-${VERSION_FILE}.tar.xz"
 	
 	wget ${URL_TAR}/${FILE_TAR} -O /opt/${FILE_TAR}
 	
	rm -fv /usr/local/bin/firefox
	rm -fv /usr/local/share/applications/firefox.desktop
	
	cd /opt
	
	tar xfv ${FILE_TAR}
	
	if [ -d "/opt/firefox" ]; then
		
		ln -s /opt/firefox/firefox /usr/local/bin/firefox
		
		wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications
		
		rm -fv ${FILE_TAR}
		
	fi
 	
 	cd -
 	
 	firefox --version
	
}

install_ytmusic()
{

	ytmusic_version
	
	URL_DEB="https://github.com/ytmdesktop/ytmdesktop/releases/download/v${VERSION_FILE}"
	
 	FILE_DEB="youtube-music-desktop-app_${VERSION_FILE}_amd64.deb"
 	
	install_deb
	
}

install_transmission()
{
	
	apt -y install transmission-common transmission-daemon transmission-cli
	
	transmission-cli --version
	transmission-daemon --version
	
}

install_nfs()
{
	
	apt -y install nfs-kernel-server
	
	cat /proc/fs/nfsd/versions
	
}

install_apps()
{
	
	apt -y install \
		python3-pandas \
		streamtuner2 \
		audacious \
  		wavemon \
		geany \
		kodi
	
	kodi --version
	geany --version
    wavemon -v
	audacious --version
  	streamtuner2 -V
	
  	rpcinfo -p | grep nfs
  	
}

install_anydesk()
{
	
	curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/anydesk.gpg
	
 	echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
	
  	apt update
	
 	apt -y install anydesk
	
}

install_teamviewer()
{
	
	URL_DEB="https://download.teamviewer.com/download/linux"
	
 	FILE_DEB="teamviewer_amd64.deb"
 	
	install_deb
	
	cat /etc/apt/sources.list.d/teamviewer.list
	
	teamviewer --version
	
}

install_virtualbox()
{
	
	apt -y install virtualbox virtualbox-source virtualbox-guest-utils
	
	virtualbox --help
	
}

install_openssh()
{
	
 	apt -y install openssh-server
	
	systemctl enable ssh
	
	systemctl status ssh
	
	openssh-server --version
  	
}

case "$1" in
	apps)
		install_apps
		;;
	config)
		config_file
		;;
  	nfs)
		install_nfs
		;;
  	opera)
		install_opera
		;;
  	google)
		install_google
		;;
	firefox)
		install_firefox
		;;
	ytmusic)
		install_ytmusic
		;;
  	anydesk)
		install_anydesk
		;;
	openssh)
		install_openssh
		;;
  	virtualbox)
		install_virtualbox
		;;
	teamviewer)
		install_teamviewer
		;;
	transmission)
		install_transmission
		;;
  	all)
  		install_apps
  		install_nfs
  		install_opera
		install_google
		install_firefox
		install_ytmusic
		install_anydesk
		install_openssh
		install_kvantum
		install_virtualbox
		install_teamviewer
		install_transmission
		config_file
		;;
	*)
		echo "Use: $0 {all|apps|config|nfs|opera|google|firefox|ytmusic|anydesk|openssh|virtualbox|teamviewer|transmission}"
		exit 1
		;;
esac
