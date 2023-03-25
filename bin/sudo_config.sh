#!/bin/sh
# Script to configure sudo on Ubuntu Desktop 22.04.2 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

APP_NAME="sudoers.d"
	
FILE_SET="lls_sudoers"

DIR_ETC="/etc/${APP_NAME}"

if [ ! -d ${DIR_ETC} ]; then

	mkdir -pv ${DIR_ETC}

fi

cp -fv etc/${APP_NAME}/${FILE_SET} ${DIR_ETC}/${FILE_SET}

chmod -v 440 ${DIR_ETC}/${FILE_SET}

ls -al ${DIR_ETC}/${FILE_SET}
