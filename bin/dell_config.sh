#!/bin/sh
# Script to configure Lubuntu on Dell Inspiron 1428
#
# Connect LAN Ethernet to Install Wireless
# Menu - Preferências - Additional Drivers - Additional Drivers
# Broadcom BCM4312
# Using dkms source for the Broadcom STAS Wireless driver for broadcom-sta-dkms (proprietary)
# Apply Changes
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

echo "Script to configure Lubuntu on Dell Inspiron 1428"

apps_install()
{
	
	bash bin/apps_install.sh google
	bash bin/apps_install.sh kvantum
	bash bin/apps_install.sh teamviewer
	
}

user_profile()
{

	cd ~

	if [ ! -d ~/cloud ]; then
	
		git clone https://github.com/lls-ws/cloud.git
		
	fi
	
	cd ~/cloud
	
	NAME=`git config user.name`

	if [ -z "${NAME}" ]; then
			
		bash bin/git_conf.sh name ${USER}
		bash bin/git_conf.sh email ${EMAIL}
		bash bin/git_conf.sh password ${USER}
		
	fi
	
	bash bin/ubuntu_conf.sh profile
	
	cd ~
	
	rm -rf ~/cloud
	
	ls ~
	
}

user_conf()
{
	
	su ${USER} -c "bash bin/user_config.sh kvantum"
	su ${USER} -c "bash bin/user_config.sh screensaver"

}

USER="wanda"
EMAIL="wganara@gmail.com"
PASSWORD="${USER}"

case "$1" in
  	apps)
		apps_install
		;;
	user)
		user_conf
		;;
	profile)
		user_profile
		;;
  	all)
		apps_install
		user_conf
		user_profile
		;;
	*)
		echo "Use: $0 {all|apps|user|profile}"
		exit 1
		;;
esac
