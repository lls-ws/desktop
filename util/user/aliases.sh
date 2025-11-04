#!/bin/sh
# Script to configure Aliases User Profile on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_user "$1"

aliases_conf()
{

	copy_home
	
	if [ -f ${FILE_ALIASES} ]; then
	
		rm -fv ${FILE_ALIASES} 
	
	fi
	
	for FILE in ~/.bash_aliases_*; do
	
		echo ${FILE}
	
		echo ". ${FILE}" >> ${FILE_ALIASES}
		
	done
	
	aliases_show
	
}

aliases_show()
{
	
	cat ${FILE_ALIASES}
	
}

FILE_ALIASES=~/.bash_aliases

FILE_NAME="bash_aliases_desktop"
FILE_SOURCE="config/${FILE_NAME}"
FILE_UPDATE=~/.${FILE_NAME}

case "$1" in
	conf)
		aliases_conf
		echo "Update File: ${FILE_ALIASES}"
		read -t 3 -p "Waiting for close terminal..."
		killall qterminal
		;;
	show)
		aliases_show
		;;
 	all)
		aliases_conf
		;;
	*)
		echo "Use: $0 {all|conf|show}"
		exit 1
		;;
esac
