#!/bin/sh
# Script to Install and Configure MiniDLNA on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

nfs_conf()
{

	apt -y install nfs-kernel-server nfs-common
	
	APP_NAME="nfs-server"
	
	FILE_SET="exports"
	
	DIR_ETC="/etc"
	
	echo "Configure ${APP_NAME}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc"

	systemctl is-enabled ${APP_NAME}

	systemctl status ${APP_NAME}

	cat ${DIR_ETC}/${FILE_SET}
	
	exportfs -rav
	
	service ${APP_NAME} stop
	
	systemctl disable ${APP_NAME}.service

}

dlna_edit()
{
	
	sudo nano /etc/minidlna.conf
	
	dlna_conf
	
}

dlna_install()
{
	
	apt -y install ${NAME_APP}
	
	dlna_conf
	
}

dlna_conf()
{
	
	dlna_version
	
	FILE_SET="${NAME_APP}.conf"
	
	DIR_ETC="etc"
	
	echo "Configure ${NAME_APP}..."
	
	update_file "${FILE_SET}" "/${DIR_ETC}" "${DIR_ETC}"

	shared_dir
	
	cat /${DIR_ETC}/${FILE_SET}
	
	echo 'DAEMON_OPTS="-R"' > /${DIR_ETC}/default/${NAME_APP}
	
	cat /${DIR_ETC}/default/${NAME_APP}
	
	chown -Rv ${NAME_APP}:${NAME_APP} /var/cache/${NAME_APP}
	
	chmod -Rv 775 /var/cache/${NAME_APP}
	
	systemctl disable ${NAME_APP}.service
	
	service ${NAME_APP} force-reload
	
	service ${NAME_APP} status
	
}

dlna_version()
{

	${NAME_APP}d -V
	
}

dlna_uninstall()
{

	clear
	
	apt -y remove --purge ${NAME_APP}
	
	apt -y autoremove
	
}

NAME_APP="minidlna"

case "$1" in
	install)
		dlna_install
		;;
	version)
		dlna_version
		;;
	conf)
		dlna_conf
		;;
	edit)
		dlna_edit
		;;
	nfs)
		nfs_conf
		;;
	uninstall)
		dlna_uninstall
		;;
	*)
		echo "Use: $0 {install|version|conf|uninstall|edit|nfs}"
		exit 1
		;;
esac
