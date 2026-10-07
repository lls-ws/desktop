#!/bin/sh
# Script to Upgrade Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

lubuntu_upgrade()
{
	
	FILE_RELEASE="/etc/update-manager/release-upgrades"
	
	sudo echo "[DEFAULT]" > ${FILE_RELEASE}
	sudo echo "Prompt=normal" >> ${FILE_RELEASE}
	
	cat ${FILE_RELEASE}
	
	sudo do-release-upgrade desktop -f DistUpgradeViewKDE
	
	featherpad admin:///etc/default/grub
	
	sudo update-grub
	
}

lubuntu_disable()
{

	echo "Criar o arquivo de ocultação oficial:"
	sudo touch /var/lib/update-notifier/hide-esm-in-motd
	
	echo "Limpeza do cache de mensagens antigas:"
	sudo /usr/lib/update-notifier/update-motd-updates-available --force
	
	ls -alh /var/lib/update-notifier/hide-esm-in-motd

}

case "$1" in
  	upgrade)
		lubuntu_upgrade
		;;
	disable)
		lubuntu_disable
		;;
  	all)
		lubuntu_upgrade
		;;
	*)
		echo "Use: $0 {all|upgrade|disable}"
		exit 1
		;;
esac
