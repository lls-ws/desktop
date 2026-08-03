#!/bin/sh
# Script to Install and Configure AppArmor on Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

clear

check_root "$1"

apparmor_install()
{
	
	apt -y install ${NAME_APP} apparmor-utils
	
}

apparmor_conf()
{
	
	FILE_APPARMOR="transmission"
	DIR_APPARMOR="etc/apparmor.d"
	
	update_file "${FILE_APPARMOR}" /${DIR_APPARMOR} "${DIR_APPARMOR}"
	
	sudo rm -fv /${DIR_APPARMOR}/${FILE_APPARMOR}.bak
	sudo rm -fv /${DIR_APPARMOR}/disable/${FILE_APPARMOR}
	
	echo "Update File : /${DIR_APPARMOR}/${FILE_APPARMOR}"
	sudo apparmor_parser -r /${DIR_APPARMOR}/${FILE_APPARMOR}
	
	echo "Restart AppArmor..."
	sudo systemctl restart ${NAME_APP}
	
	echo "Restart Transmission..."
	sudo systemctl restart transmission-daemon
	
}

apparmor_remove()
{
	
	echo "Desative e pare o serviço do AppArmor"
	sudo systemctl stop ${NAME_APP}
	sudo systemctl disable ${NAME_APP}
	
	echo "Remova os pacotes do AppArmor do sistema"
	sudo apt purge -y ${NAME_APP} apparmor-utils
	
	echo "Limpe as pastas de configurações e perfis residuais"
	sudo rm -rf /etc/apparmor.d/ /var/lib/${NAME_APP}/
	
	echo "Reinicie o servidor para descarregar o módulo do kernel"
	sudo reboot
	
}

NAME_APP="apparmor"

case "$1" in
	install)
		apparmor_install
		;;
	conf)
		apparmor_conf
		;;
	remove)
		apparmor_remove
		;;
  	all)
  		apparmor_install
  		apparmor_conf
  		;;
	*)
		echo "Use: $0 {all|install|conf|remove}"
		exit 1
		;;
esac
