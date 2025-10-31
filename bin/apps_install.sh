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

install_minidlna()
{
	
	apt -y install minidlna
	
	minidlnad -V
	
}

install_nfs()
{
	
	apt -y install nfs-kernel-server
	
	cat /proc/fs/nfsd/versions
	
}

install_samba()
{
	
	apt -y install samba
	
	smbd -V
	
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
	
	sshd -V
  	
}

case "$1" in
	nfs)
		install_nfs
		;;
	samba)
		install_samba
		;;
	opera)
		install_opera
		;;
	config)
		config_file
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
  	minidlna)
		install_minidlna
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
  		install_nfs
  		install_samba
  		install_opera
		install_google
		install_firefox
		install_ytmusic
		install_anydesk
		install_openssh
		install_minidlna
		install_virtualbox
		install_teamviewer
		install_transmission
		config_file
		;;
	*)
		echo "Use: $0 {all|config|nfs|samba|opera|google|firefox|ytmusic|anydesk|openssh|minidlna|virtualbox|teamviewer|transmission}"
		exit 1
		;;
esac
