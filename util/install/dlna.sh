#!/bin/sh
# Script to Install and Configure MiniDLNA on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

dlna_install()
{
	
	apt -y install ${NAME_APP}
	
	dlna_conf
	
}

dlna_conf()
{
	
	dlna_version
	
	DIR_ETC="/etc"
	
	echo "Configure ${NAME_APP}..."
	
	update_file "${FILE_CONF}" "${DIR_ETC}" "${DIR_ETC}"

	shared_dir
	
	cat ${DIR_ETC}/${FILE_CONF}
	
	echo 'DAEMON_OPTS="-R"' > ${DIR_ETC}/default/${NAME_APP}
	
	cat ${DIR_ETC}/default/${NAME_APP}
	
	chown -Rv ${NAME_APP}:${NAME_APP} /var/cache/${NAME_APP}
	
	chmod -Rv 775 /var/cache/${NAME_APP}
	
	systemctl disable ${NAME_APP}.service
	
	service ${NAME_APP} force-reload
	
	service ${NAME_APP} status
	
}

dlna_edit()
{
	
	sudo nano ${FILE_CONF}
	
	dlna_conf
	
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
FILE_CONF="${NAME_APP}.conf"

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
