#!/bin/sh
# Script to install apps on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

lubuntu_update()
{
	
	FILE_RELEASE="/etc/update-manager/release-upgrades"
	
	sudo echo "[DEFAULT]" > ${FILE_RELEASE}
	sudo echo "Prompt=normal" >> ${FILE_RELEASE}
	
	cat ${FILE_RELEASE}
	
	sudo do-release-upgrade -m desktop -f DistUpgradeViewKDE
	
	featherpad admin:///etc/default/grub
	
	sudo update-grub
	
}

apps_install()
{
	
	bash bin/3green_config.sh intel
	
	bash bin/apps_install.sh apps
	bash bin/apps_install.sh opera
	bash bin/apps_install.sh google
	bash bin/apps_install.sh firefox
	bash bin/apps_install.sh ytmusic
	bash bin/apps_install.sh anydesk
	bash bin/apps_install.sh kvantum
	bash bin/apps_install.sh virtualbox
	bash bin/apps_install.sh teamviewer
	
}

util_conf()
{
	bash bin/util_config.sh sudo
	bash bin/util_config.sh hosts
	bash bin/util_config.sh scripts
}

user_conf()
{
	
	USER=`git config user.name`
	
	echo "User: ${USER}"
	
	if [ ! -z "${USER}" ]; then
		
		su ${USER} -c "bash bin/user_config.sh all"
		
	fi

}

daemon_conf()
{
	
	bash bin/daemon_config.sh nfs
	bash bin/daemon_config.sh sddm
	bash bin/daemon_config.sh transmission
	
}

case "$1" in
  	update)
		lubuntu_update
		;;
  	apps)
		apps_install
		;;
	daemon)
		daemon_conf
		;;
  	util)
		util_conf
		;;
	user)
		user_conf
		;;
  	all)
		apps_install
		daemon_conf
		util_conf
		user_conf
		;;
	*)
		echo "Use: $0 {all|update|apps|daemon|util|user}"
		exit 1
		;;
esac
