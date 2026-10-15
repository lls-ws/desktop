#!/bin/sh
# Script to Disable Services on Lubuntu Desktop Start
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

clear

check_root "$1"

services_disable()
{

	for SERVICE in "${SERVICES[@]}"
	do
		
		sudo systemctl stop "${SERVICE}.service"
		
		sudo systemctl disable "${SERVICE}.service"
		
	done
	
	services_list
	
}

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


	
	
}

SERVICES=(
	"transmission-daemon"
	"cups-browsed"
	"teamviewerd"
	"anydesk"
	"openvpn"
	"tomcat9"
	"mariadb"
	"cups"
	"cron"
	"ssh"
)

case "$1" in
	disable)
		services_disable
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
	all)
		services_disable
		services_show
		services_load
		services_boot
		;;
	*)
		echo "Use: $0 {disable|show|load|boot|list}"
		exit 1
		;;
esac
