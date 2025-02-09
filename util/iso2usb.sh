#!/bin/sh
# Script to copy video files
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

create_usb()
{
	
	FILE_ISO="lubuntu-24.10-desktop-amd64.iso"
	
	PATH_ISO=${DIR_ISO}/${FILE_ISO}
	
	echo ${PATH_ISO}
	
	if [ -f ${PATH_ISO} ]; then
	
		sudo dd if=${PATH_ISO} of=/dev/sdb bs=1M status=progress
	
	else
	
		echo "File not found!"
		exit 1;
	
	fi
	  
}

DIR_SHARE="/mnt/shared"

DIR_ISO="${DIR_SHARE}/iso"

create_usb
