#!/bin/sh
# Script to Backup Apps User Profile on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_user "$1"

clear

FILES_SET=(
	"vlc"
	"mpv"
	"lxqt"
	"geany"
	"openbox"
	"kvantum"
	"autostart"
)

echo "Creating Backup Apps File..."

for FILE_SET in "${FILES_SET[@]}"
do
	
	echo -e "\nBackup: ${FILE_SET}"
	
	DIR_UPDATE=config/${FILE_SET}
	
	for FILE in ${DIR_UPDATE}/*; do
	
		FILE="$(basename "${FILE}")"
	
		update_file ${FILE} ${DIR_UPDATE} ~/.${DIR_UPDATE}
		
	done

	ls -al ${DIR_UPDATE}
		
done

FILE_SET="xscreensaver"

DIR_UPDATE=config/${FILE_SET}

echo -e "\nBackup: ${FILE_SET}"

cp -fv ~/.${FILE_SET} ${DIR_UPDATE}

ls -al ${DIR_UPDATE}

bash util/user/kodi.sh backup

echo -e "\nBackup done!"
