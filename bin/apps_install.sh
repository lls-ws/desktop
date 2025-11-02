#!/bin/sh
# Script to install apps on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

install_nfs()
{
	
	apt -y install nfs-kernel-server
	
	cat /proc/fs/nfsd/versions
	
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
	all)
  		install_nfs
		install_anydesk
		install_openssh
		install_virtualbox
		install_teamviewer
		;;
	*)
		echo "Use: $0 {all|nfs|anydesk|openssh|virtualbox|teamviewer}"
		exit 1
		;;
esac
