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
	
	echo "Definir o IP:"
	sudo ip addr add 192.168.0.2/24 dev ${INTERFACE}
	
	file_update "00-installer-config.yaml" "etc/netplan"
	
	echo "Aplique as mudanças:"
	sudo netplan apply
	
	ip addr show
	
	resolvectl status
	
	echo "Install Ping:"
	sudo apt -y install inetutils-ping
	
	ping -c 3 google.com
	
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

apps_install()
{
	
	SCRIPT_OPT="$1"
	
	DIR_SCRIPT="util/${SCRIPT_OPT}"
	
	bash "${DIR_SCRIPT}/transmission.sh" ${SCRIPT_OPT}
	#bash "${DIR_SCRIPT}/dlna.sh" ${SCRIPT_OPT}
	#bash "${DIR_SCRIPT}/docker.sh" ${SCRIPT_OPT}
	
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
	
	su lls -c "bash bin/user_conf.sh ssh-remote lls"
	
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
  	install)
		apps_install "install"
		;;
  	bin)
		list_dir "usr/bin"
		;;
  	all)
		net_conf
		ssh_install
		grub_conf
		server_conf
		;;
	*)
		echo "Use: $0 {all|net|ssh|grub|conf|key|remote}"
		exit 1
		;;
esac
