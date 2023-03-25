#!/bin/sh
# Script to change brightness
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

FILE_CONF="/sys/class/backlight/acpi_video0/brightness"

VALOR=`cat ${FILE_CONF}`

if [ -z "$1" ]; then

	VALOR=0
	
else

	VALOR=$1

	if [ ${VALOR} -gt 7 ]; then

		VALOR=7

	fi

fi

echo -n ${VALOR} > ${FILE_CONF}

cat ${FILE_CONF}
