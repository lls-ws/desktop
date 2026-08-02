#!/bin/sh
# Script to Install and Configure AppArmor on Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

clear

check_root "$1"

apparmor_conf()
{
	
	FILE_APPARMOR="transmission"
	DIR_APPARMOR="etc/apparmor.d"
	
	transmission_copy "${FILE_APPARMOR}" "${DIR_APPARMOR}"
	
	sudo rm -fv /${DIR_APPARMOR}/${FILE_APPARMOR}.bak
	
	echo "Update File : /${DIR_APPARMOR}/${FILE_APPARMOR}"
	sudo apparmor_parser -r /${DIR_APPARMOR}/${FILE_APPARMOR}
	
	echo "Reload AppArmor..."
	sudo systemctl reload apparmor
	
}

apparmor_remove()
{
	
	echo "Desative e pare o serviço do AppArmor"
	sudo systemctl stop apparmor
	sudo systemctl disable apparmor
	
	echo "Remova os pacotes do AppArmor do sistema"
	sudo apt purge -y apparmor apparmor-utils
	
	echo "Limpe as pastas de configurações e perfis residuais"
	sudo rm -rf /etc/apparmor.d/ /var/lib/apparmor/
	
	echo "Reinicie o servidor para descarregar o módulo do kernel"
	sudo reboot
	
}

case "$1" in
	remove)
		apparmor_remove
		;;
	conf)
		apparmor_conf
		;;
  	all)
  		apparmor_conf
  		;;
	*)
		echo "Use: $0 {all|remove|conf}"
		exit 1
		;;
esac
