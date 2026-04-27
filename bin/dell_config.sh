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
	
	INTERFACE="enp8s0"
	
	echo "Verificar interfaces: state UP"
	ip addr
	
	echo "Verificar a conexão física: Link detected yes"
	sudo ethtool ${INTERFACE}
	
	echo "Retorna 1 para conectado:"
	cat /sys/class/net/${INTERFACE}/carrier
	
	echo "Subir a interface:"
	sudo ip link set ${INTERFACE} up
	
	FILE_YAML="01-netcfg.yaml"
	DIR_NETPLAN="etc/netplan"
	
	file_update "${FILE_YAML}" "${DIR_NETPLAN}"
	
	sudo chmod 600 /${DIR_NETPLAN}/${FILE_YAML}
	
	echo "Aplique as mudanças:"
	sudo netplan apply
	
	ip addr show
	
	resolvectl status
	
	echo "Install Ping:"
	sudo apt -y install inetutils-ping
	
	ping -c 3 google.com
	
	ping6 -c 3 google.com
	
}

ssh_install()
{
	
	echo "Install SSH:"
	sudo apt -y install nano openssh-server git
	
	sudo systemctl status ssh
	sudo systemctl start ssh
	sudo systemctl status ssh
	sudo systemctl enable ssh
	
	ss -tuln | grep :22
	
}

grub_conf()
{
	
	echo "Configure Grub:"
	
	file_update "grub" "etc/default"
	
	logind_conf
	
	sudo update-grub
	
}

logind_conf()
{
	
	echo "Configure Logind:"
	
	file_update "logind.conf" "etc/systemd"
	
	sudo systemctl restart systemd-logind
	
}

server_conf()
{
	
	echo "Configure Sudo:"
	sudo bash util/conf/sudo.sh conf
	
	echo -e "\nConfigure Hosts:"
	sudo bash util/conf/hosts.sh conf
	
	echo -e "\nConfigure Aliases:"
	su lls -c "bash util/user/aliases.sh all"
	
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
	
	su lls -c "bash bin/user_conf.sh ssh-local dell dell lls"
	
	cd ${DIR_LLS}/desktop
	
}

ssh_remote()
{
	
	check_cloud
	
	sudo bin/git_conf.sh name lls
	
	su lls -c "bash bin/user_conf.sh ssh-remote lls lls lls"
	
	su lls -c "bash bin/user_conf.sh aliases"
	
	cd ${DIR_LLS}/desktop
	
}

case "$1" in
  	net)
		net_conf
		;;
  	ssh)
		ssh_install
		;;
  	grub)
		grub_conf
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
  	script)
		file_update "video_copy.sh" "usr/bin"
		;;
  	all)
		net_conf
		ssh_install
		grub_conf
		server_conf
		sudo bash util/install/transmission.sh install
		sudo bash util/install/dlna.sh install
		sudo bash util/install/docker.sh install
		sudo bash util/install/nfs.sh install
		;;
	*)
		echo "Use: $0 {all|net|ssh|grub|conf|key|remote|script}"
		exit 1
		;;
esac
