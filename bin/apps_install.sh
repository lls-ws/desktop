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

remove_packages()
{
	
	dpkg --list | grep ^rc
	
	PACKAGE_LIST=$(dpkg --list | grep ^rc| awk '{ print $2}')
	
	echo "${PACKAGE_LIST}"
	
	apt-get -y --purge remove ${PACKAGE_LIST}
	
}

install_deb()
{
	
	wget ${URL_DEB}/${FILE_DEB}
	
	sudo apt -y install ./${FILE_DEB}
	
 	rm -fv ${FILE_DEB}
	
}

install_opera()
{
	
	VERSION_DEB="117.0.5408.53"
	
	URL_DEB="https://download3.operacdn.com/ftp/pub/opera/desktop/${VERSION_DEB}/linux"
 	
 	FILE_DEB="opera-stable_${VERSION_DEB}_amd64.deb"
 	
	install_deb
	
	cat /etc/apt/sources.list.d/opera-stable.list
	
	opera --version
	
}

install_google()
{

	URL_DEB="https://dl.google.com/linux/direct"
	
 	FILE_DEB="google-chrome-stable_current_amd64.deb"
 	
 	install_deb
 	
  	echo "Set Google to default mailto"
  	xdg-settings set default-url-scheme-handler mailto google-chrome.desktop
  	xdg-settings get default-url-scheme-handler mailto
  	
  	echo "Set Google to default mailto"
  	xdg-mime default google-chrome.desktop x-scheme-handler/whatsapp
  	xdg-mime query default x-scheme-handler/whatsapp
	
 	google-chrome --version
	
}

install_firefox()
{
	
	sudo snap remove firefox
 	
 	VERSION_TAR="136.0.2"
	
	URL_TAR="https://download-installer.cdn.mozilla.net/pub/firefox/releases/${VERSION_TAR}/linux-x86_64/pt-BR"
 	
 	FILE_TAR="firefox-${VERSION_TAR}.tar.xz"
 	
 	sudo wget ${URL_TAR}/${FILE_TAR} -O /opt/${FILE_TAR}
 	
	sudo rm -fv /usr/local/bin/firefox
	sudo rm -fv /usr/local/share/applications/firefox.desktop
	
	cd /opt
	
	sudo tar xfv ${FILE_TAR}
	
	if [ -d "/opt/firefox" ]; then
		
		sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
		
		sudo wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications
		
		sudo rm -fv ${FILE_TAR}
		
	fi
 	
 	cd -
	
}

install_ytmusic()
{

	VERSION_DEB="2.0.8"
	
	URL_DEB="https://github.com/ytmdesktop/ytmdesktop/releases/download/v${VERSION_DEB}"
	
 	FILE_DEB="youtube-music-desktop-app_${VERSION_DEB}_amd64.deb"
 	
	install_deb
	
}

install_apps()
{
	
	apt -y install \
		transmission-common \
		transmission-daemon \
		nfs-kernel-server \
		transmission-cli \
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
	
	apt -y install virtualbox virtualbox-guest-utils
	
	virtualbox --help
	
}

case "$1" in
	apps)
		install_apps
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
	kvantum)
		install_kvantum
		;;
  	virtualbox)
		install_virtualbox
		;;
	teamviewer)
		install_teamviewer
		;;
	remove)
		remove_packages
		;;	
  	all)
  		install_apps
  		install_opera
		install_google
		install_firefox
		install_ytmusic
		install_anydesk
		install_kvantum
		install_virtualbox
		install_teamviewer
		;;
	*)
		echo "Use: $0 {all|remove|apps|opera|google|firefox|ytmusic|anydesk|kvantum|virtualbox|teamviewer}"
		exit 1
		;;
esac
