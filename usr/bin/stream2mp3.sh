#!/bin/bash
# Script para salvar stream mp3
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

DIR_MP3="/home/shared/musica"

echo "Salvando MP3 na pasta: ${DIR_MP3}"
streamripper "http://radio2.vip-radios.fm:8036/stream-64kmp3-IbizaRelax_autodj" -d ${DIR_MP3} --xs_none
