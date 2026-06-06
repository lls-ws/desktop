#!/bin/sh
# Script to configure LLS Profile on Dell Inspiron
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

clear

wifi_config()
{
	
	sudo apt -y purge broadcom-sta-dkms
	sudo rm -fv /etc/modprobe.d/broadcom-sta-dkms.conf
	sudo apt update
	sudo apt -y install firmware-b43-installer
	sudo modprobe -r b43 ssb
	sudo modprobe b43
	lspci -nnk | grep -iA3 net
	ping -c 3 google.com
	
}

apps_install()
{
	
	sudo apt -y install geany
	
	sudo bash util/install/google.sh install
	sudo bash util/install/firefox.sh install
	sudo bash util/install/opera.sh install
	sudo bash util/install/ytmusic.sh install
	
}

git_config()
{
	
	cd ~/cloud
	
	sudo bin/git_conf.sh name lls
	sudo bin/git_conf.sh email lls.homeoffice@gmail.com
	
	sudo bin/git_conf.sh password 
	sudo bin/git_conf.sh token 
	echo -e "\nRun this command above to configure GitHub!"
	
}

cloud_config()
{
	
	cd ~
	git clone https://github.com/lls-ws/cloud.git && cd cloud
	
	sudo bin/ubuntu_conf.sh upgrade
	sudo bin/ubuntu_conf.sh fonts
	
}
	
desktop_config()
{	
	
	bash util/user/xscreensaver.sh conf
	bash util/user/aliases.sh all
	
	bash util/user/config.sh Kvantum
	bash util/user/config.sh geany
	bash util/user/config.sh openbox
	bash util/user/config.sh autostart

	bash util/user/lxqt.sh all

	sudo bash bin/3green_config.sh bin

	sudo bash util/conf/applications.sh conf
	
	sudo bash util/conf/sudo.sh conf
	sudo bash util/conf/hosts.sh conf
	sudo bash util/conf/sddm.sh conf
	
	sudo bash bin/dell_config.sh grub
	
}

case "$1" in
  	wifi)
		wifi_config
		;;
  	cloud)
		cloud_config
		;;
	apps)
		apps_install
		;;
	git)
		git_config
		;;
	desktop)
		desktop_config
		;;
	all)
		wifi_config
		cloud_config
		git_config
		apps_install
		desktop_config
		;;
	*)
		echo "Use: $0 {all|wifi|cloud|apps|aliases|git|desktop}"
		exit 1
		;;
esac
