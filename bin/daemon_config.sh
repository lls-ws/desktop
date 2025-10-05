#!/bin/sh
# Script to configure daemon service on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

bluetooth_conf()
{
	
	APP_NAME="bluetooth"
	
	echo "Configure ${APP_NAME}..."
	
	systemctl enable ${APP_NAME}

 	systemctl start ${APP_NAME}

  	systemctl status ${APP_NAME}
	
}

sddm_conf()
{
	git clone https://github.com/RadRussianRus/sddm-slice.git
	
 	mv -v sddm-slice /usr/share/sddm/themes/sddm-slice
	
	FILE_SET="/etc/sddm.conf"
 	
  	echo "[Theme]" >> ${FILE_SET}
   	echo "Current=sddm-slice" >> ${FILE_SET}
	
    cat ${FILE_SET}
	
}

lightdm_conf()
{
	
	APP_NAME="lightdm"
	
	FILE_SET="slick-greeter.conf"
	
	DIR_ETC="/etc/${APP_NAME}"
	
	echo "Configure ${APP_NAME}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc/${APP_NAME}"
	
	apt -y purge gdm3 unity-greeter
	
	apt -y autoremove
	
	dpkg-reconfigure lightdm
	
	cat /etc/X11/default-display-manager
	
	cp -fv images/wallpaper.png /usr/share/backgrounds
	
}

transmission_conf()
{
	
	APP_NAME="transmission-daemon"
	
	FILE_SET="settings.json"
	
	DIR_ETC="/etc/${APP_NAME}"
	
	echo "Configure ${APP_NAME}..."
	
	echo "Stop ${APP_NAME} service..."
	service ${APP_NAME} stop
	
	if [ ! -f "${DIR_ETC}/${FILE_SET}.bak" ]; then
	
		echo "Create backup ${FILE_SET}.bak"
		cp -fv ${DIR_ETC}/${FILE_SET} ${DIR_ETC}/${FILE_SET}.bak
		
	fi
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc/${APP_NAME}"
	
	echo "Changing File ${FILE_SET} owner to ${USER_TRANSMISISON}"
	chown -v ${USER_TRANSMISISON}:${USER_TRANSMISISON} ${DIR_ETC}/${FILE_SET}
	
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
	
	FILE_SERVICE="/etc/systemd/system/transmission-daemon.service"
	
	sed -i "s/Type=notify/Type=simple/g" ${FILE_SERVICE}
	
	cat ${FILE_SERVICE}
	
	echo "Disable startup service ${APP_NAME}"
	systemctl disable ${APP_NAME}.service
	
	echo "Check your ports 51413 are open!"
	echo "Configure Port Forward on internet router setup"
	
}

nfs_conf()
{
	
	APP_NAME="nfs-server"
	
	FILE_SET="exports"
	
	DIR_ETC="/etc"
	
	echo "Configure ${APP_NAME}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc"

	systemctl is-enabled ${APP_NAME}

	systemctl status ${APP_NAME}

	shared_dir
	
	exportfs -a
	
	cat ${DIR_ETC}/${FILE_SET}
	
	exportfs -rav
	
	service ${APP_NAME} stop
	
	systemctl disable ${APP_NAME}.service

}

minidlna_conf()
{
	
	APP_NAME="minidlna"
	
	FILE_SET="minidlna.conf"
	
	DIR_ETC="/etc"
	
	echo "Configure ${APP_NAME}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc"

	shared_dir
	
	cat ${DIR_ETC}/${FILE_SET}
	
	echo 'DAEMON_OPTS="-R"' > ${DIR_ETC}/default/${APP_NAME}
	
	cat ${DIR_ETC}/default/${APP_NAME}
	
	chown -Rv ${APP_NAME}:${APP_NAME} /var/cache/${APP_NAME}
	
	chmod -Rv 775 /var/cache/${APP_NAME}
	
	service ${APP_NAME} force-reload
	
	systemctl disable ${APP_NAME}.service

}

shared_dir()
{
	
	DIR_SHD="/mnt/shared"
	
	if [ ! -d ${DIR_SHD} ]; then
	
		mkdir -pv ${DIR_SHD}
		
	fi
	
	DIRS_SET=(
		"filmes"
		"series"
		"musica"
		"iso"
		"log"
	)
	
	for DIR_SET in "${DIRS_SET[@]}"
	do
		
		DIR_SET=${DIR_SHD}/${DIR_SET}
		
		if [ ! -d ${DIR_SET} ]; then
	
			mkdir -v ${DIR_SET}
			
		fi
			
	done
	
	chown -Rv ${USER_TRANSMISISON}:${USER_TRANSMISISON} ${DIR_SHD}
	
	chmod -Rv 777 ${DIR_SHD}
	
	ls -al ${DIR_SHD}
	
}

USER_TRANSMISISON="debian-transmission"

case "$1" in
	nfs)
		nfs_conf
		;;
	sddm)
		sddm_conf
		;;
	lightdm)
		lightdm_conf
		;;
	minidlna)
		minidlna_conf
		;;
	bluetooth)
		bluetooth_conf
		;;
 	transmission)
		transmission_conf
		;;
	all)
		nfs_conf
		sddm_conf
		lightdm_conf
		minidlna_conf
		bluetooth_conf
		transmission_conf
		;;
	*)
		echo "Use: $0 {all|nfs|sddm|lightdm|minidlna|bluetooth|transmission}"
		exit 1
		;;
esac
