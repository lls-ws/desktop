#!/bin/sh
# Script to Install and Configure Intel Video Driver on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

intel_install()
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
 	
	intel_show
	
	echo "Type: reboot"
	
}

intel_show()
{
	
	vainfo
	
}

case "$1" in
  	install)
		intel_install
		;;
  	show)
		intel_show
		;;
  	all)
		intel_install
		intel_show
		;;
	*)
		echo "Use: $0 {all|install|show}"
		exit 1
		;;
esac
