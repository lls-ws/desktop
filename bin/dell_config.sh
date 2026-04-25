#!/bin/sh
# Script to configure Ubuntu Server on Dell Inspiron
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

clear

net_conf()
{
	
	echo "Verificar interfaces: state UP"
	ip addr
	
	echo "Verificar a conexão física: Link detected yes"
	sudo ethtool enp8s0
	
	echo "Retorna 1 para conectado:"
	cat /sys/class/net/enp8s0/carrier
	
	echo "Subir a interface:"
	sudo ip link set enp8s0 up
	
	echo "Definir o IP:"
	sudo ip addr add 192.168.0.2/24 dev enp8s0
	
	FILE_SET="00-installer-config.yaml"
	DIR_ETC="etc/netplan"
	
	echo "Configure ${FILE_SET}..."
	
	update_file "${FILE_SET}" "/${DIR_ETC}" "${DIR_ETC}"
	
	ls -al /${DIR_ETC}/${FILE_SET}
	
	util_show
	
	echo "Aplique as mudanças:"
	sudo netplan apply
	
}

user_conf()
{
	
	USER=`git config user.name`
	
	echo "User: ${USER}"
	
	if [ ! -z "${USER}" ]; then
		
		su ${USER} -c "bash util/user/aliases.sh all"
		
		
	fi

}

server_install()
{
	
	SCRIPT_OPT="$1"
	
	DIR_SCRIPT="util/${SCRIPT_OPT}"
	
	bash "${DIR_SCRIPT}/transmission.sh" ${SCRIPT_OPT}
	#bash "${DIR_SCRIPT}/dlna.sh" ${SCRIPT_OPT}
	#bash "${DIR_SCRIPT}/docker.sh" ${SCRIPT_OPT}
	
}

server_conf()
{
	
	SCRIPT_OPT="$1"
	
	DIR_SCRIPT="util/${SCRIPT_OPT}"
	
	bash "${DIR_SCRIPT}/sudo.sh" ${SCRIPT_OPT}
	
}

case "$1" in
  	install)
		server_install "install"
		;;
  	conf)
		server_conf "conf"
		;;
  	user)
		user_conf
		;;
  	bin)
		list_dir "usr/bin"
		;;
  	all)
		server_install "install"
		server_conf "conf"
		list_dir "usr/bin"
		user_conf
		;;
	*)
		echo "Use: $0 {all|install|conf|user|bin}"
		exit 1
		;;
esac
