#!/bin/bash
# Script para salvar stream mp3
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

DIR_MP3="/home/shared/musica"
URL_RADIO="http://radio2.vip-radios.fm:8036/stream-64kmp3-IbizaRelax_autodj"

if [ `hostname` = "3green" ]; then

	DIR_MP3="/home/lls/.musica"
	
	if [ ! -d "${DIR_MP3}" ]; then
	
		mkdir -pv "${DIR_MP3}"
		
	fi

fi

echo "Salvando MP3 na pasta: ${DIR_MP3}"
echo "URL Radio: ${URL_RADIO}"
streamripper ${URL_RADIO} -d ${DIR_MP3} --xs_none
