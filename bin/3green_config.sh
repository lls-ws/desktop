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
  	
  	FILE_ENV="/etc/environment"
  	
  	sed -i '/^$/d' ${FILE_ENV}
  	sed -i '/LIBVA_DRIVER_NAME=i965/d' ${FILE_ENV}
	sed -i '/XDG_RUNTIME_DIR=/d' ${FILE_ENV}
  	
	echo "LIBVA_DRIVER_NAME=i965" >> ${FILE_ENV}
	echo "XDG_RUNTIME_DIR=/run/user/1000" >> ${FILE_ENV}

	cat ${FILE_ENV}
	
	export LIBVA_DRIVER_NAME=i965
	export XDG_RUNTIME_DIR=/run/user/$(id -u)
 	
	vainfo
	
	echo "Type: reboot"
	
}

install_app()
{
	
	APP_NAME="$1"
	
	bash util/${APP_NAME}.sh install
	
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
  	google)
		install_app "$1"
		;;
  	opera)
		install_app "$1"
		;;
  	all)
		intel_driver
		install_app google
		install_app opera
		;;
	*)
		echo "Use: $0 {all|intel|google|opera}"
		exit 1
		;;
esac
