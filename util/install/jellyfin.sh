#!/bin/sh
# Script to Install and Configure Jellyfin on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

jellyfin_edit()
{
	
	sudo nano /etc/minijellyfin.conf
	
	jellyfin_conf
	
}

jellyfin_install()
{
	
	curl -s https://repo.jellyfin.org/install-debuntu.sh | sudo bash
	
	#apt -y install ${NAME_APP}
	
	#jellyfin_conf
	
}

jellyfin_conf()
{
	
	jellyfin_version
	
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

jellyfin_version()
{

	${NAME_APP}d -V
	
}

jellyfin_uninstall()
{

	clear
	
	apt -y remove --purge ${NAME_APP}
	
	apt -y autoremove
	
}

NAME_APP="jellyfin"

case "$1" in
	install)
		jellyfin_install
		;;
	version)
		jellyfin_version
		;;
	conf)
		jellyfin_conf
		;;
	edit)
		jellyfin_edit
		;;
	nfs)
		nfs_conf
		;;
	uninstall)
		jellyfin_uninstall
		;;
	*)
		echo "Use: $0 {install|version|conf|uninstall|edit|nfs}"
		exit 1
		;;
esac
