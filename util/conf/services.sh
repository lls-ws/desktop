#!/bin/sh
# Script to Disable Services on Lubuntu Desktop Start
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

clear

check_root "$1"

services_show()
{
	
	service --status-all
	
}

services_load()
{
	
	systemctl -t service --state=active
	
}

services_boot()
{
	
	systemctl list-unit-files --state=enabled
	
}

services_list()
{
	
	ls /etc/systemd/system/multi-user.target.wants
	
}

services_mask()
{

	echo "Telemetria e relatórios de erro do Ubuntu (Consomem muita CPU)"
	sudo systemctl disable --now ubuntu-advantage.service ua-reboot-cmds.service whoopsie.path
	sudo systemctl mask ubuntu-advantage.service ua-reboot-cmds.service whoopsie.path
	
	echo "Suporte a Modems 3G/Dispositivos móveis antigos (Inútil para Wi-Fi/Cabo)"
	sudo systemctl disable --now ModemManager.service
	sudo systemctl mask ModemManager.service
	
	echo "Estatísticas de sistema e Agendador secundário"
	sudo systemctl disable --now sysstat.service anacron.service
	
	echo "Desativa e para o temporizador do anacron"
	sudo systemctl disable --now anacron.timer
	
	echo "Mascara o temporizador para garantir que nada consiga reativá-lo"
	sudo systemctl mask anacron.timer
	
	echo "Desativar Descoberta de Rede e Impressão"
	sudo systemctl disable --now avahi-daemon.service legacy-printer-app.service
	sudo systemctl mask avahi-daemon.service legacy-printer-app.service

	echo "Para e desativa o socket do Avahi"
	sudo systemctl disable --now avahi-daemon.socket
	
	echo "Mascara o socket para impedir que ele seja reativado por outros programas"
	sudo systemctl mask avahi-daemon.socket

	echo "Desativar Atualizações de Segurança de Fundo"
	sudo systemctl disable --now unattended-upgrades.service

	echo "Desativa e para os serviços e timers do APT diário"
	sudo systemctl disable --now apt-daily.service apt-daily.timer

	echo "Para e desativa os timers residualmente"
	sudo systemctl disable --now apt-daily.timer apt-daily-upgrade.timer

	echo "Mascara os timers para impedir qualquer ativação automática"
	sudo systemctl mask apt-daily.timer apt-daily-upgrade.timer
	
	echo "Mascara os serviços para garantir que o sistema não os force a iniciar"
	sudo systemctl mask apt-daily.service apt-daily-upgrade.service

	echo "Desativar o serviço de verificação de disco desnecessário"
	sudo systemctl disable --now e2scrub_reap.service
	sudo systemctl mask e2scrub_reap.service

	echo "Desativar o Networkd-Dispatcher"
	sudo systemctl disable --now networkd-dispatcher.service
	sudo systemctl mask networkd-dispatcher.service

}

services_analyze()
{

	systemd-analyze blame
	systemd-analyze
	
}

packages_list()
{
	
	echo "Listar todos os pacotes instalados:"
	dpkg --get-selections
	
}

hardware_show()
{
	
	fastfetch
	
}

hardware_details()
{
	
	inxi -Fz
	
}

case "$1" in
	hardware)
		hardware_show
		;;
	details)
		hardware_details
		;;
	show)
		services_show
		;;
	load)
		services_load
		;;
	boot)
		services_boot
		;;
	list)
		services_list
		;;
	mask)
		services_mask
		;;
	analyze)
		services_analyze
		;;
	packages)
		packages_list
		;;
	all)
		services_disable
		services_show
		services_load
		services_boot
		;;
	*)
		echo "Use: $0 {disable|show|load|boot|list|mask|analyze|packages}"
		exit 1
		;;
esac
