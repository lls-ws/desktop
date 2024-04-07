#!/bin/sh
# Script to Copy Videos from Youtube
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

video_copy()
{
	
	yt-dlp ${URL_VIDEO}
	
}

URL_VIDEO="$2"

case "$1" in
	copy)
		video_copy
		;;
	*)
		echo "Use: $0 {show|copy} [URL_VIDEO]"
		exit 1
		;;
esac
