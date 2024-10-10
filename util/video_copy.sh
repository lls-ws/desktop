#!/bin/sh
# Script to copy video files
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

video_total()
{
	
	find ${DIR_VIDEO} -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mkv" | wc -l >> ${FILE_LOG}
	
}

video_show()
{
	
	find ${DIR_VIDEO} -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mkv" | awk -F/ '{print $NF}' > ${FILE_LOG}
	
	video_total
	
}

video_copy()
{
	
	video_show
	
	du -hsc ${DIR_MOVIES} | head -1 >> ${FILE_LOG}
	du -hsc ${DIR_VIDEO} | head -1 >> ${FILE_LOG}
	du -hsc ${DIR_VIDEO}/.incomplete | head -1 >> ${FILE_LOG}
	
	if [ -f ${VIDEO_LOG} ]; then
	
		chown ${USER_TRANSMISISON}:${USER_TRANSMISISON} ${VIDEO_LOG}
	
	fi
	
	COUNT=0
	
	find ${DIR_VIDEO} -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mkv" |
	
	while read FILE; do
	  
	  mv -fv "${FILE}" ${DIR_MOVIES} >> ${FILE_LOG}
	  
	  echo $(basename "${FILE}") >> ${VIDEO_LOG}
	  
	  ((COUNT++))
	  
	  echo -e "${COUNT}" >> ${FILE_LOG}
	  
	done
	
	audio_copy
	
	rm -rf ${DIR_VIDEO}/* >> ${FILE_LOG}
	
	ls ${DIR_VIDEO} >> ${FILE_LOG}
	
	du -hsc ${DIR_MOVIES} | head -1 >> ${FILE_LOG}
	
	video_log
	
}

video_log()
{
	
	FILE_LOG="${DIR_LOG}/filmes.log"
	
	if [ -f ${FILE_LOG} ]; then
	
		rm -f ${FILE_LOG}
	
	fi
	
	find ${DIR_MOVIES} -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mkv" | awk -F/ '{print $NF}' | sort > ${FILE_LOG}
	
	chown ${USER_TRANSMISISON}:${USER_TRANSMISISON} ${FILE_LOG}
	
	cat ${FILE_LOG}
	
}

audio_copy()
{
	
	COUNT=0
	
	find ${DIR_VIDEO} -iname "*.mp3" -o -iname "*.flac" |
	
	while read FILE; do
	  
	  mv -fv "${FILE}" ${DIR_MUSICA} >> ${FILE_LOG}
	  
	  echo $(basename "${FILE}") >> ${VIDEO_LOG}
	  
	  ((COUNT++))
	  
	  echo -e "${COUNT}" >> ${FILE_LOG}
	  
	done
	
}

DIR_VIDEO="/home/torrents"

DIR_SHARE="/mnt/shared"

DIR_MOVIES="${DIR_SHARE}/filmes"

DIR_SERIES="${DIR_SHARE}/series"

DIR_MUSICA="${DIR_SHARE}/musica"

DIR_LOG="${DIR_SHARE}/log"

VIDEO_LOG="${DIR_LOG}/video.log"

FILE_LOG="${DIR_LOG}/copy-`date +"%Y_%m_%d-%H_%M_%S"`.log"

USER_TRANSMISISON="debian-transmission"

case "$1" in
	show)
		video_show
		;;
	total)
		video_total
		;;
	copy)
		video_copy
		;;
	log)
		video_log
		;;
	*)
		video_copy
		;;
esac
