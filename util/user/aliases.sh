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
	
		FILE=$(basename ${FILE})
	
		echo '. /home/$USER/'${FILE}'' >> ${FILE_ALIASES}
		
	done
	
	echo "# Se não for uma sessão interativa, pare a execução aqui" > ~/.bashrc
	echo -e '[[ $- != *i* ]] && return\n' >> ~/.bashrc

	cat ~/.bash_aliases >> ~/.bashrc
	
	echo -e "\n# Conecta automaticamente no SSH se o terminal for o do Geany" >> ~/.bashrc
	echo '#if [ -n "$GEANY_WINDOW" ] || [ "$PPID" = "$(pgrep geany)" ]; then' >> ~/.bashrc
	echo "#    connect_dev" >> ~/.bashrc
	echo "#fi" >> ~/.bashrc
	
	source ~/.bashrc
	
	aliases_show
	
}

aliases_show()
{
	
	cat ${FILE_ALIASES} ~/.bashrc
	
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
