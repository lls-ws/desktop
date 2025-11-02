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

	rm -fv ${FILE_ALIASES}
	
	cp -fv config/${FILE_NAME} ${FILE_CLOUD}
	
	for FILE in ~/.bash_aliases_*; do
	
		echo ${FILE}
	
		echo ". ${FILE}" >> ${FILE_ALIASES}
		
	done
	
	aliases_show
	
	echo "Pressione uma tecla para fechar!"
	read -t 3 -p "Aguardando..."
	killall qterminal
	
}

aliases_show()
{
	
	cat ${FILE_CLOUD} ${FILE_ALIASES}
	
}

FILE_ALIASES=~/.bash_aliases
	
FILE_NAME="bash_aliases_desktop"
	
FILE_CLOUD=~/.${FILE_NAME}

case "$1" in
	conf)
		aliases_conf
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
