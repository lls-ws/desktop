#!/bin/sh
# Script to Install and Configure NFS on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

nfs_install()
{

	apt -y install nfs-kernel-server nfs-common
	
	nfs_conf
	
}

nfs_conf()
{

	DIR_ETC="/etc"
	
	echo "Configure ${NAME_APP}..."
	
	update_file "${FILE_CONF}" "${DIR_ETC}" "etc"

	sudo chmod -v 644 ${DIR_ETC}/${FILE_CONF}

	systemctl is-enabled ${NAME_APP}

	systemctl status ${NAME_APP}

	ls -alh ${DIR_ETC}/${FILE_CONF}

	cat ${DIR_ETC}/${FILE_CONF}
	
	exportfs -rav
	
	systemctl enable ${NAME_APP}.service
	
	sudo systemctl restart nfs-kernel-server

}

nfs_version()
{

	${NAME_APP}d -V
	
}

nfs_edit()
{
	
	sudo nano ${FILE_CONF}
	
	nfs_conf
	
}

nfs_uninstall()
{

	clear
	
	apt -y remove --purge ${NAME_APP}
	
	apt -y autoremove
	
}

nfs_local()
{
	
	DIR_SHARED="/home/shared"
	
	sudo mkdir -p ${DIR_SHARED}
	
	sudo chown nobody:nogroup ${DIR_SHARED}
	
	sudo chmod 777 ${DIR_SHARED}
	
	ls -alh ${DIR_SHARED}
	
	sudo apt -y install nfs-common
	
	sudo mount -t nfs 192.168.0.2:${DIR_SHARED} ${DIR_SHARED}
	
}

NAME_APP="nfs-server"
FILE_CONF="exports"

case "$1" in
	install)
		nfs_install
		;;
	version)
		nfs_version
		;;
	conf)
		nfs_conf
		;;
	edit)
		nfs_edit
		;;
	local)
		nfs_local
		;;
	uninstall)
		nfs_uninstall
		;;
	*)
		echo "Use: $0 {install|version|conf|uninstall|edit|local}"
		exit 1
		;;
esac
