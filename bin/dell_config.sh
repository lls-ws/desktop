#!/bin/sh
# Script to configure LLS Profile Desktop on Notebook Dell Inspiron
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
	
	sudo apt -y install audacious geany qalculate-qt qpdfview
	
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

case "$1" in
  	wifi)
		wifi_config
		;;
	apps)
		apps_install
		;;
	git)
		git_config
		;;
	all)
		wifi_config
		apps_install
		git_config
		;;
	*)
		echo "Use: $0 {all|wifi|apps|git}"
		exit 1
		;;
esac
