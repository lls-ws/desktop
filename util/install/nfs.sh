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

	apt -y install nfs-kernel-server
	
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

	echo "Suporte Ativo para Versões: `sudo cat /proc/fs/nfsd/versions`"
	
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
	uninstall)
		nfs_uninstall
		;;
	*)
		echo "Use: $0 {install|version|conf|uninstall|edit}"
		exit 1
		;;
esac
