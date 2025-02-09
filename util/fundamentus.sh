#!/bin/sh
# Script to get all Real Estate Funds Quotes
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

set_edit()
{
	
	geany ${DIR_LLS}/*.txt &
	
}

get_html()
{

	if [ -f ${FILE_HTML} ]; then

		rm -fv ${FILE_HTML}

	fi
	
	URL_FIIS="${URL_BASE}/fii_resultado.php"
	
	echo -e "\nHTML: ${FILE_HTML}"
	echo "URL: ${URL_FIIS}"
	
	wget --user-agent="Mozilla" ${URL_FIIS} -O ${FILE_HTML}
	
	if [ -f ${FILE_HTML} ]; then
	
		du -hsc ${FILE_HTML}
		
	fi
	
}

read_html()
{

	if [ -f ${FILE_HTML} ]; then
	
		du -hsc ${FILE_HTML}
		
		python3 util/read.py
		
	fi
	
}

clear

FILE_NAME="fundamentus"

FILE_HTML="/tmp/${FILE_NAME}.html"

URL_BASE="https://www.${FILE_NAME}.com.br"

case "$1" in
	html)
		get_html
		;;
	read)
		read_html
		;;
	all)
		get_html
		;;
	*)
		echo "Use: $0 {all|html|read}"
		exit 1
		;;
esac
