#!/bin/sh
# Script to configure Ubuntu Server on Dell Inspiron
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

clear

file_update()
{
	
	FILE_SET="$1"
	DIR_ETC="$2"
	
	echo "Configure ${FILE_SET}..."
	
	update_file "${FILE_SET}" "/${DIR_ETC}" "${DIR_ETC}"
	
	ls -al /${DIR_ETC}/${FILE_SET}
	
	util_show
	
}

net_conf()
{
	
	echo "Interface: enp8s0"
	
	file_update "50-cloud-init.yaml" "etc/netplan"
	
	sudo chmod 600 /${DIR_ETC}/${FILE_SET}
	
	echo "Aplique as mudanças:"
	sudo netplan apply
	
	sudo systemctl start ssh
	sudo systemctl enable ssh
	
	sudo shutdown -r now
		
}

grub_conf()
{
	
	echo "Configure Grub:"
	
	file_update "grub" "etc/default"
	
	file_update "40_custom" "etc/grub.d"
	
	sudo update-grub
	
}

logind_conf()
{
	
	echo "Configure Logind:"
	
	file_update "logind.conf" "etc/systemd"
	
	echo "Reiniciar o serviço de login:"
	sudo systemctl restart systemd-logind
	
	echo "Desativar completamente os alvos de suspensão (Garante o Boot):"
	sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
	
}

server_conf()
{
	
	echo "Configure Sudo:"
	sudo bash util/conf/sudo.sh conf
	
	echo -e "\nConfigure Hosts:"
	sudo bash util/conf/hosts.sh conf
	
	echo -e "\nConfigure Aliases:"
	su lls -c "bash util/user/aliases.sh all"
	
	echo "Configure MOTD:"
	
	file_update "99-custom-info" "etc/update-motd.d"
	
	sudo chmod +x /${DIR_ETC}/${FILE_SET}
	
}
	
ssh_local()
{
	
	check_cloud
	
	su lls -c "ssh-keygen -f '/home/lls/.ssh/known_hosts' -R 'dell.lls.net.br'"
	
	su lls -c "bash bin/user_conf.sh ssh-local dell dell lls"
	
	cd ${DIR_LLS}/desktop
	
}

ssh_remote()
{
	
	check_cloud
	
	sudo bin/git_conf.sh name "lls"
	sudo bin/git_conf.sh email "lls.home.office@gmail.com"
	sudo bin/git_conf.sh password "123456"
	
	su lls -c "bash bin/user_conf.sh ssh-remote lls lls lls"
	
	su lls -c "bash bin/user_conf.sh aliases"
	
	cd ${DIR_LLS}/desktop
	
}

set_profile()
{
	
	check_cloud
	
	echo "Configure Locale:"
	sudo bash bin/ubuntu_conf.sh profile
	
	cd ${DIR_LLS}/desktop
	
}

crontab_config()
{
	
	echo "Configure Crontabs:"
	
	file_update "root" "var/spool/cron/crontabs"
	
	chmod -v 0600 /${DIR_ETC}/${FILE_SET}
	
	echo "Show crontab jobs..."
	crontab -l
	
	echo "Restarting crontab..."
	service cron restart
	
}

server_disable()
{
	
	echo "Desativar Serviços:"
	sudo systemctl disable --now apport plymouth plymouth-log unattended-upgrades
	
	echo "Mascarar Serviços:"
	sudo systemctl mask apport plymouth plymouth-log unattended-upgrades

	echo "Remover configurações residuais de serviços inúteis:"
	sudo apt purge -y apport plymouth unattended-upgrades
	
	echo "Desativar Serviços de Nuvem:"
	sudo systemctl disable --now cloud-config.service cloud-final.service cloud-init-local.service cloud-init.service cloud-init-hotplugd.socket

	echo "Remover Serviços de Nuvem:"
	sudo apt purge -y cloud-init
	sudo rm -rfv /etc/cloud/ /var/lib/cloud/
	
	echo "Pare socket e serviço Snap:"
	sudo systemctl stop snapd.socket snapd.service

	echo "Desative socket e serviço Snap:"
	sudo systemctl disable snapd.socket snapd.service
	
	echo "Desative e remova o Snap do sistema:"
	sudo systemctl disable --now snapd.seeded.service snapd.autoimport.service snapd.apparmor.service snapd.snap-repair.timer
	
	echo "Remova o pacote snapd:"
	sudo apt purge -y snapd

	echo "Elimine as pastas residuais do snap:"
	sudo rm -rf /var/cache/snapd/ /root/snap /var/snap /snap
	
	echo "Para serviço e socket Multipath:"
	sudo systemctl stop multipathd.service multipathd.socket
	
	echo "Desativa serviço e socket Multipath:"
	sudo systemctl disable multipathd.service multipathd.socket
	
	echo "Aplica um mask no serviço e socket Multipath:"
	sudo systemctl mask multipathd.service multipathd.socket
	
	echo "Para serviço e socket iSCSI:"
	sudo systemctl stop open-iscsi.service iscsid.socket
	
	echo "Desativa serviço e socket iSCSI:"
	sudo systemctl disable open-iscsi.service iscsid.socket
	
	echo "Aplica um mask no serviço e socket iSCSI:"
	sudo systemctl mask open-iscsi.service iscsid.socket
	
	echo "Desativa o instalador automático do LXD:"
	sudo systemctl disable --now lxd-installer.socket
	
	echo "Desativa o gerenciador térmico da Intel:"
	sudo systemctl disable --now thermald.service
	
	echo "Desativa o dispatcher de rede:"
	sudo systemctl disable --now networkd-dispatcher.service
	
	echo "Desativar Serviços de Telemetria e Anúncios da Canonical:"
	sudo systemctl disable --now ua-reboot-cmds.service ubuntu-advantage.service ua-timer.timer motd-news.timer pollinate.service

	echo "Para os serviços binfmt blk backlight:"
	sudo systemctl stop systemd-binfmt blk-availability systemd-backlight@backlight:acpi_video0
	
	echo "Desativa os serviços binfmt blk backlight:"
	sudo systemctl disable systemd-binfmt blk-availability systemd-backlight@backlight:acpi_video0
	
	echo "Aplica um mask nos serviços binfmt blk backlight:"
	sudo systemctl mask systemd-binfmt blk-availability systemd-backlight@backlight:acpi_video0
	
	echo "Desativa o serviço e2scrub:"
	sudo systemctl disable --now e2scrub_reap.service
	
	echo "Aplica um mask no serviço e2scrub:"
	sudo systemctl mask e2scrub_reap.service

	echo "Desativa o serviço systemd-networkd-wait-online:"
	sudo systemctl disable systemd-networkd-wait-online.service
	
	echo "Aplica um mask no serviço systemd-networkd-wait-online:"
	sudo systemctl mask systemd-networkd-wait-online.service

	echo "Limpe os pacotes órfãos do sistema:"
	sudo apt autoremove --purge -y
	
}

server_remove()
{
	
	echo "Remove cabeçalhos, ferramentas de debug de performance e traços de kernels antigos:"
	sudo apt purge -y bpfcc-tools bpftrace trace-cmd strace linux-headers-6.8.0-142 linux-headers-6.8.0-142-generic linux-headers-6.8.0-147 linux-headers-6.8.0-147-generic linux-headers-generic linux-tools-6.8.0-142 linux-tools-6.8.0-142-generic linux-tools-6.8.0-147 linux-tools-6.8.0-147-generic linux-tools-common

	echo "Remover Clientes de Protocolos Obsoletos e Inseguros:"
	sudo apt purge -y inetutils-telnet telnet ftp tnftp

	echo "Remover Pacotes de Armazenamento Corporativo e Redundantes:"
	sudo apt purge -y multipath-tools open-iscsi lxd-installer bcache-tools
	
	echo "Remover Telemetria e Clientes Corporativos da Canonical:"
	sudo apt purge -y ubuntu-pro-client ubuntu-pro-client-l10n pollinate

	echo "Remover diretórios desnecessários:"
	sudo rm -rf /var/lib/update-manager /etc/pollinate

	echo "Remover Utilitários de Hardware Desnecessários:"
	sudo apt purge -y thermald networkd-dispatcher

	echo "Remover Drivers e Codecs Gráficos Inúteis:"
	sudo apt purge -y mesa-va-drivers mesa-vdpau-drivers mesa-vulkan-drivers va-driver-all vdpau-driver-all xauth

	echo "Remove utilitários de ambiente desktop e importação de chaves SSH de nuvem:"
	sudo apt purge -y xdg-user-dirs ssh-import-id

	echo "Remover automaticamente todos pacotes com status deinstall:"
	dpkg --get-selections | grep deinstall | awk '{print $1}' | xargs -r sudo apt purge -y

	echo "Limpe os pacotes órfãos do sistema:"
	sudo apt autoremove --purge -y

	sudo apt clean
	
	sudo update-grub
	
}

server_swap()
{
	
	echo "Cria um arquivo vazio de 2 Gigabytes no sistema:"
	sudo fallocate -l 2G /swapfile

	echo "Ajusta as permissões de segurança para que apenas o sistema acesse:"
	sudo chmod -v 600 /swapfile

	echo "Formata o arquivo como espaço de Swap:"
	sudo mkswap /swapfile

	echo "Ativa o arquivo de Swap imediatamente:"
	sudo swapon /swapfile
	
	echo "Adicione no arquivo de montagem do sistema:"
	echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
	
}

case "$1" in
  	net)
		net_conf
		;;
  	grub)
		grub_conf
		;;
	logind)
		logind_conf
		;;
  	conf)
		server_conf
		;;
	key)
		ssh_local
		;;
	remote)
		ssh_remote
		;;
  	profile)
		set_profile
		;;
  	cron)
		crontab_config
		;;
  	disable)
		server_disable
		;;
	remove)
		server_remove
		;;
	swap)
		server_swap
		;;
	all)
		net_conf
		grub_conf
		server_conf
		grub_conf
		logind_conf
		set_profile
		crontab_config
		server_disable
		server_remove
		;;
	*)
		echo "Use: $0 {all|net|grub|logind|conf|key|remote|profile|cron|disable|remove|swap}"
		exit 1
		;;
esac
