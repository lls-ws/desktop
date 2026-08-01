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
	
	# LAN
	FILE_YAML="50-cloud-init.yaml"
	DIR_NETPLAN="etc/netplan"
	
	file_update "${FILE_YAML}" "${DIR_NETPLAN}"
	
	sudo chmod 600 /${DIR_NETPLAN}/${FILE_YAML}
	
	echo "Aplique as mudanças:"
	sudo netplan apply
	
	sudo systemctl enable ssh
	
	sudo reboot
		
}

ssh_install()
{
	
	echo "Install SSH:"
	sudo apt -y install nano openssh-server git
	
	file_update "sshd_config" "etc/ssh"
	
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

script_conf()
{
	
	FILE_SH="video_copy.sh"
	DIR_SH="var/lib/transmission-daemon/scripts"
	
	file_update "${FILE_SH}" "${DIR_SH}"
	
	sudo chmod +x /${DIR_SH}/${FILE_SH}
	sudo chown -Rv ${USER_TRANSMISISON}:${USER_TRANSMISISON} /${DIR_SH}
	
	ls -alh /${DIR_SH}/${FILE_SH}
	
	sudo bash util/install/transmission.sh conf

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
	sddm)
		sddm_conf "$2"
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
  	script)
		script_conf
		;;
  	all)
		net_conf
		ssh_install
		grub_conf
		server_conf
		grub_conf
		sddm_conf
		sudo bash util/install/transmission.sh install
		sudo bash util/install/dlna.sh install
		sudo bash util/install/docker.sh install
		sudo bash util/install/nfs.sh install
		script_conf
		;;
	*)
		echo "Use: $0 {all|net|ssh|grub|sddm|logind|conf|key|remote|script|profile}"
		exit 1
		;;
esac
