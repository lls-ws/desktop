#!/bin/sh
# Script to install apps on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

show_version()
{
	
	lsb_release -a
	
}

apps_install()
{
	
	bash bin/apps_install.sh apps
	bash bin/apps_install.sh google
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
	version)
		show_version
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
		echo "Use: $0 {all|version|apps|daemon|util|user}"
		exit 1
		;;
esac
