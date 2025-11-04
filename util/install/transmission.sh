#!/bin/sh
# Script to Install and Configure Transmission on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

transmission_install()
{
	
	apt -y install ${NAME_APP}
	
	transmission_conf
	
}

transmission_conf()
{
	
	echo "Stop ${NAME_APP} service..."
	service ${NAME_APP} stop
	
	transmission_copy "settings.json" "etc/${NAME_APP}"
	
	FILE_APPARMOR="transmission"
	DIR_APPARMOR="etc/apparmor.d"
	
	transmission_copy "${FILE_APPARMOR}" "${DIR_APPARMOR}"
	
	echo "Update File : /${DIR_APPARMOR}/${FILE_APPARMOR}"
	apparmor_parser -r /${DIR_APPARMOR}
	
	transmission_dir
	
	echo "Disable startup service ${NAME_APP}"
	systemctl disable ${NAME_APP}.service
	
	echo "Start ${NAME_APP} service..."
	service ${NAME_APP} start
	
	service ${NAME_APP} status
	
	echo "Check your ports 51413 are open!"
	echo "Configure Port Forward on Router Setup"
	
}

transmission_copy()
{
	
	FILE_SET="$1"
	
	DIR_ETC="$2"
	
	echo "Configure ${FILE_SET}..."
	
	if [ ! -f "${DIR_ETC}/${FILE_SET}.bak" ]; then
	
		echo "Create backup ${FILE_SET}.bak"
		cp -fv /${DIR_ETC}/${FILE_SET} /${DIR_ETC}/${FILE_SET}.bak
		
	fi
	
	update_file "${FILE_SET}" "/${DIR_ETC}" "${DIR_ETC}"
	
	echo "Changing File ${FILE_SET} owner to ${USER_TRANSMISISON}"
	chown -v ${USER_TRANSMISISON}:${USER_TRANSMISISON} /${DIR_ETC}/${FILE_SET}
	
}

transmission_dir()
{	
	
	DIR_TRANSMISSION="/home/torrents"
	
	if [ ! -d "${DIR_TRANSMISSION}" ]; then
	
		echo "Creating Directory ${DIR_TRANSMISSION}"
		mkdir -pv ${DIR_TRANSMISSION}/.incomplete
	
	fi
	
	echo "Changing Directory ${DIR_TRANSMISSION} owner to ${USER_TRANSMISISON}"
	chown -Rv ${USER_TRANSMISISON}:${USER_TRANSMISISON} ${DIR_TRANSMISSION}
	
	USER=`git config user.name`
	
	echo "User: ${USER}"
	
	if [ ! -z "${USER}" ]; then
	
		echo "Add the username ${USER} to the group ${USER_TRANSMISISON}:"
		sudo usermod -a -G ${USER_TRANSMISISON} ${USER}
		
		echo "Showing username ${USER} groups:"
		groups ${USER}
		
	fi
	
	echo "Fixing bug: Type=notify"
	
	FILE_SERVICE="/etc/systemd/system/${NAME_APP}.service"
	
	sed -i "s/Type=notify/Type=simple/g" ${FILE_SERVICE}
	
	cat ${FILE_SERVICE}
	
}

transmission_version()
{

	${NAME_APP} --version	
	
}

transmission_uninstall()
{

	clear
	
	apt -y remove --purge ${NAME_APP}
	
	apt -y autoremove
	
}

NAME_APP="transmission-daemon"

case "$1" in
	install)
		transmission_install
		;;
	version)
		transmission_version
		;;
	conf)
		transmission_conf
		;;
	uninstall)
		transmission_uninstall
		;;
  	all)
  		transmission_install
  		transmission_version
  		transmission_conf
  		;;
	*)
		echo "Use: $0 {all|install|version|conf|uninstall}"
		exit 1
		;;
esac
