#!/bin/sh
# Script to configure Lubuntu Desktop on 3Green
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

clear

install_apps()
{
	
	APPS_NAME=(
		"intel"
		"google"
		"opera"
		"firefox"
		"ytmusic"
		"transmission"
		"dlna"
	)
	
	for APP_NAME in "${APPS_NAME[@]}"
	do
		
		bash util/${APP_NAME}.sh install
			
	done
	
}

util_conf()
{
	bash bin/util_config.sh sudo
	bash bin/util_config.sh hosts
	bash bin/util_config.sh scripts
}

user_conf()
{
	
	USER=`git config user.name`
	
	echo "User: ${USER}"
	
	if [ ! -z "${USER}" ]; then
		
		su ${USER} -c "bash bin/user_config.sh all"
		
	fi

}

case "$1" in
  	apps)
		install_apps
		;;
  	all)
		install_apps
		;;
	*)
		echo "Use: $0 {all|apps}"
		exit 1
		;;
esac
