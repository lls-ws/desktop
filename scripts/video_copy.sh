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
	
	COUNT=0
	
	find ${DIR_VIDEO} -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mkv" |
	
	while read FILE; do
	  
	  mv -fv "${FILE}" ${DIR_MOVIES} >> ${FILE_LOG}
	  
	  echo $(basename "${FILE}") >> ${VIDEO_LOG}
	  
	  ((COUNT++))
	  
	  echo -e "${COUNT}" >> ${FILE_LOG}
	  
	done
	
	rm -rf ${DIR_VIDEO}/* >> ${FILE_LOG}
	
	ls ${DIR_VIDEO} >> ${FILE_LOG}
	
	du -hsc ${DIR_MOVIES} | head -1 >> ${FILE_LOG}
	
	video_log
	
}

video_log()
{
	
	FILE_LOG="${DIR_LOG}/filmes.log"
	
	find ${DIR_MOVIES} -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mkv" | awk -F/ '{print $NF}' | sort | nl -n ln > ${FILE_LOG}
	
	cat ${FILE_LOG}
	
}

DIR_VIDEO="/home/torrents"

DIR_SHARE="/mnt/shared"

DIR_MOVIES="${DIR_SHARE}/filmes"

DIR_SERIES="${DIR_SHARE}/series"

DIR_LOG="${DIR_SHARE}/log"

VIDEO_LOG="${DIR_LOG}/video.log"

FILE_LOG="${DIR_LOG}/copy-`date +"%Y_%m_%d-%H_%M_%S"`.log"

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
