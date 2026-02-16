#!/bin/sh
# Script to copy Youtube video files
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

search_video()
{

	URL_VIDEO="$1"
	
	yt-dlp -F ${URL_VIDEO}
	
}

copy_video()
{
	
	ID_VIDEO="$1"
	
	if [ -z "${ID_VIDEO}" ]; then
	
		echo "ID Video not found!"
		echo "Run: $(basename $0) copy [ID_VIDEO] [URL_VIDEO]"
		exit 1
	
	fi
	
	URL_VIDEO="$2"
	
	if [ -z "${URL_VIDEO}" ]; then
	
		echo "URL Video not found!"
		echo "Run: $(basename $0) copy [ID_VIDEO] [URL_VIDEO]"
		exit 1
	
	fi
	
	echo "Copy Youtube video:"
	
	if [ ! -d ${DIR_YT} ]; then
	
		mkdir -pv ${DIR_YT}
	
	fi
	
	yt-dlp -f "${ID_VIDEO}" --cookies-from-browser chrome -P "${DIR_YT}" "${URL_VIDEO}"
	
	ls -alh ${DIR_YT}
	
}

cut_video()
{

	yt-dlp -F "${URL_VIDEO}"
	
}

DIR_YT="/mnt/shared/series/XGDP/Youtube"

case "$1" in
	search)
		search_video "$2"
		;;
	copy)
		copy_video "$2" "$3"
		;;
	cut)
		cut_video
		;;
	*)
		echo "Use: $(basename $0) {search|copy|cut}"
		exit 1
		;;
esac
