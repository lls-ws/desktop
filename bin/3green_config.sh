#!/bin/sh
# Script to configure Lubuntu on 3Green
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

clear

intel_driver()
{
 	
	apt-get -y purge --auto-remove mesa-vulkan-drivers
  	
  	apt -y install vainfo
	
  	lspci -k | grep i915
  	
	echo "LIBVA_DRIVER_NAME=i965" >> /etc/environment

	cat /etc/environment
	
	export LIBVA_DRIVER_NAME=i965
 	
	vainfo

	echo "Type: reboot"
	
}

apps_install()
{
	
	bash bin/3green_config.sh intel
	
	bash bin/apps_install.sh nfs
	bash bin/apps_install.sh opera
	bash bin/apps_install.sh google
	bash bin/apps_install.sh firefox
	bash bin/apps_install.sh ytmusic
	bash bin/apps_install.sh anydesk
	bash bin/apps_install.sh teamviewer
	bash bin/apps_install.sh transmission
	
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
  	intel)
		intel_driver
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
		intel_driver
		apps_install
		daemon_conf
		util_conf
		user_conf
		;;
	*)
		echo "Use: $0 {all|intel|apps|daemon|util|user}"
		exit 1
		;;
esac
