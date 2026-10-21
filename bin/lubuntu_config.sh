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
	
	ls -alh /var/lib/update-notifier/hide-esm-in-motd

	echo "Remover o cliente Ubuntu Pro"
	sudo apt purge -y ubuntu-pro-client
	
	echo "Remova dependências desnecessárias:"
	sudo apt autoremove --purge -y

	echo "Remova os diretórios residuais:"
	sudo rm -rfv /var/lib/ubuntu-pro-client /etc/ubuntu-pro

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
		lubuntu_disable
		;;
	*)
		echo "Use: $0 {all|upgrade|disable}"
		exit 1
		;;
esac
