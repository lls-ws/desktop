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
	
check_cloud()
{
	
	DIR_LLS="/home/lls"
	DIR_CLOUD="${DIR_LLS}/cloud"
	
	if [ ! -d ${DIR_CLOUD} ]; then
	
		(cd ${DIR_LLS}; git clone https://github.com/lls-ws/cloud.git)
	
	fi
	
	cd ${DIR_CLOUD}
	
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
  	all)
		net_conf
		grub_conf
		server_conf
		grub_conf
		logind_conf
		set_profile
		crontab_config
		;;
	*)
		echo "Use: $0 {all|net|grub|logind|conf|key|remote|profile|cron}"
		exit 1
		;;
esac
