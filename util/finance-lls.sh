#!/bin/sh
# Script to get real estate funds values
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

get_html()
{

	NAMES=(
		"snel11"
		"knsc11"
		"mxrf11"
		"cpts11"
		"bcff11"
	)

	for NAME in "${NAMES[@]}"
	do
		
		FILE_HTML="/tmp/${NAME}.html"
		
		echo -e "\nFUND: ${NAME}"
		echo "HTML: ${FILE_HTML}"
		echo "URL: ${URL_FUND}/${NAME}"
		
		wget ${URL_FUND}/${NAME} -O ${FILE_HTML} 
		
		if [ -f ${FILE_HTML} ]; then
		
			get_yield
			get_pvp
			get_revenue
			
		fi
		
		
	done
	
	rm -fv /tmp/*.html
	
	echo -e "\nShowing File: ${FILE_LLS}"
	
	cat ${FILE_LLS}
}

get_yield()
{

	YIELD=`cat ${FILE_HTML} | grep -B 5 'Soma total de' | head -1 | cut -d '>' -f 2 | cut -d '<' -f 1`
	
	echo "Get Dividend Yield: ${YIELD}%"
	
}

get_pvp()
{

	PVP=`cat ${FILE_HTML} | grep -B 4 'Valor de mercado' | head -1 | cut -d '>' -f 2 | cut -d '<' -f 1`
	
	echo "Get P/VP: ${PVP}"
	
}

get_revenue()
{

	REVENUE=`cat ${FILE_HTML} | grep -A 6 'Último rendimento' | tail -1 | cut -d '>' -f 2 | cut -d '<' -f 1`
	
	echo "Get Revenue: ${REVENUE}"
	
	add_value
	
}

add_value()
{

	echo "${YIELD}%;${PVP};${REVENUE}" >> ${FILE_LLS}
	
}

clear

URL_FUND="https://statusinvest.com.br/fundos-imobiliarios"

FILE_LLS=~/`basename ${0%.*}`.csv

echo "FILE: ${FILE_LLS}"

if [ -f ${FILE_LLS} ]; then

	rm -fv ${FILE_LLS}

fi

get_html
