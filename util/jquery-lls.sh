#!/bin/sh
# Script to Compile a JS Project
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

DIR_LLS="/home/lls/lls-src"

if [ ! -d ${DIR_LLS} ]; then

	echo "Directory not found: ${DIR_LLS}"
	exit 1;

fi

cd ${DIR_LLS}

bash bin/jquery_conf.sh start "$1"

cd ~
