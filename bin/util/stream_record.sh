#!/bin/sh
# Script to record mp3 from stream radios
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

record_radio()
{
	
	LINE_NUMBER="$1"
	
	DIR_MP3="/home/${USER}/Música"
	
	PLAY_LIST="/home/${USER}/.config/audacious/playlists/1000.audpl"
	
	URL_RADIO=`cat ${PLAY_LIST} | grep uri | cut -f 2 -d "=" | sed -n ''${LINE_NUMBER}'p'`
	
	echo ${LINE_NUMBER}
	echo ${DIR_MP3}
	echo ${PLAY_LIST}
	echo ${URL_RADIO}
	
	streamripper ${URL_RADIO} -d ${DIR_MP3} -s
	
}

USER=`git config user.name`

if [ -z "${USER}" ]; then
		
	echo "Not found a user name!"
	echo "Use: git_conf.sh name {NAME}"
	exit 1
	
fi

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
