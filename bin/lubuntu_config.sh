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

case "$1" in
  	upgrade)
		lubuntu_upgrade
		;;
  	all)
		lubuntu_upgrade
		;;
	*)
		echo "Use: $0 {all|upgrade}"
		exit 1
		;;
esac
