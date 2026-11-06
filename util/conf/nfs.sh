#!/bin/sh
# Script to configure NFS Client on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

fstab_conf()
{
	
	echo "Configure ${FILE_SET}..."
	
	update_file "${FILE_SET}" "/${DIR_ETC}" "${DIR_ETC}"
	
	util_show
	
	echo "Aplicar as mudanças sem reiniciar:"
	sudo systemctl daemon-reload
	sudo systemctl restart remote-fs.target
	
}

nfs_conf()
{
	
	DIRS_NFS=(
		"dell"
		"funchal"
	)
	
	for DIR_NFS in "${DIRS_NFS[@]}"
	do
		
		if [ ! -d /media/${DIR_NFS} ]; then
	
			sudo mkdir -pv /media/${DIR_NFS}
		
		fi
		
		sudo chmod -v 777 /media/${DIR_NFS}
		
		sudo chown -v lls:lls /media/${DIR_NFS}
			
	done
	
	ls -alh /media
	
	fstab_conf
	
}

FILE_SET="fstab"
DIR_ETC="etc"

case "$1" in
	conf)
		nfs_conf
		;;
	show)
		util_show
		;;
	fstab)
		fstab_conf
		;;
	*)
		echo "Use: $0 {conf|show|fstab}"
		exit 1
		;;
esac
