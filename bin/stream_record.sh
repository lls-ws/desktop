#!/bin/sh
# Script to record mp3 from stream radios
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

record_radio()
{
	
	LINE_NUMBER="$1"
	
	DIR_MP3="/home/lls/Música"
	
	PLAY_LIST="/home/lls/.config/audacious/playlists/1000.audpl"
	
	URL_RADIO=`cat ${PLAY_LIST} | grep uri | cut -f 2 -d "=" | sed -n ''${LINE_NUMBER}'p'`
	
	echo ${LINE_NUMBER}
	echo ${DIR_MP3}
	echo ${PLAY_LIST}
	echo ${URL_RADIO}
	
	streamripper ${URL_RADIO} -d ${DIR_MP3} -s
	
}

case "$1" in
	1)
		record_radio "$1"
		;;
	uturn)
		record_radio "1"
		;;
	*)
		echo "Use: $0 {uturn}"
		exit 1
		;;
esac
