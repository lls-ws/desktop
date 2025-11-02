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
	uninstall)
		dlna_uninstall
		;;
  	all)
  		dlna_install
  		dlna_version
  		dlna_conf
  		;;
	*)
		echo "Use: $0 {all|install|version|conf|uninstall}"
		exit 1
		;;
esac
