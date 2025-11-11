#!/bin/sh
# Script to Backup Apps User Profile on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_user "$1"

clear

apps_array

APPS_CONF+=("lxqt")

echo "Creating Backup Apps File..."

for NAME_APP in "${APPS_CONF[@]}"
do
	
	echo -e "\nBackup: ${NAME_APP}"
	
	DIR_UPDATE=config/${NAME_APP}
	
	for FILE in ${DIR_UPDATE}/*; do
	
		FILE="$(basename "${FILE}")"
	
		update_file ${FILE} ${DIR_UPDATE} ~/.${DIR_UPDATE}
		
	done

	ls -al ${DIR_UPDATE}
		
done

NAME_APP="xscreensaver"

DIR_UPDATE=config/${NAME_APP}

echo -e "\nBackup: ${NAME_APP}"

cp -fv ~/.${NAME_APP} ${DIR_UPDATE}

ls -al ${DIR_UPDATE}

bash util/user/kodi.sh backup

echo -e "\nBackup done!"
