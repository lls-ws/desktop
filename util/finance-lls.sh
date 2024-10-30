#!/bin/sh
# Script to get real estate funds values
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

set_fiis()
{

	FUND_TYPE="fundos-imobiliarios"
	
	TICKERS=(
		"snel11"
		"knsc11"
		"mxrf11"
		"cpts11"
		"alzm11"
	)
	
	get_html
	
}

set_fiagro()
{

	FUND_TYPE="fiagros"
	
	TICKERS=(
		"snag11"
		"iagr11"
	)
	
	get_html
	
}

get_html()
{

	FILE_FUND=~/${FUND_TYPE}.csv

	for TICKER in "${TICKERS[@]}"
	do
		
		FILE_HTML="/tmp/${TICKER}.html"
		
		URL_TICKER=${URL_BASE}/${FUND_TYPE}/${TICKER}
		
		echo -e "\nTICKER: ${TICKER}"
		echo "TYPE: ${FUND_TYPE}"
		echo "HTML: ${FILE_HTML}"
		echo "URL: ${URL_TICKER}"
		
		wget ${URL_TICKER} -O ${FILE_HTML}
		
		if [ -f ${FILE_HTML} ]; then
		
			get_yield
			get_pvp
			get_revenue
			
		fi
		
	done
	
	rm -fv /tmp/*.html
	
	echo -e "\nShowing File: ${FILE_FUND}"
	
	cat ${FILE_FUND}
}

get_yield()
{

	YIELD=`cat ${FILE_HTML} | grep -B 5 'Soma total de' | head -1 | cut -d '>' -f 2 | cut -d '<' -f 1`
	
	check_value "Dividend Yield" "${YIELD}"
	
}

get_pvp()
{

	PVP=`cat ${FILE_HTML} | grep -B 4 'Valor de mercado' | head -1 | cut -d '>' -f 2 | cut -d '<' -f 1`
	
	check_value "P/VP" "${PVP}"
	
}

get_revenue()
{

	REVENUE=`cat ${FILE_HTML} | grep -A 6 'Último rendimento' | tail -1 | cut -d '>' -f 2 | cut -d '<' -f 1`
	
	check_value "Revenue" "${REVENUE}"
	
	add_values
	
}

add_values()
{

	echo -e "\nAdd values to file: ${FILE_FUND}"
	
	echo "${YIELD}%;${PVP};${REVENUE}" >> ${FILE_FUND}
	
}

check_value()
{
	
	TEXT="$1"
	VALUE="$2"
	
	if [ -n "${VALUE}" ]; then
	
		echo "Get ${TEXT}: ${VALUE}%"
	
	else
	
		echo "${TEXT} not found!"
		exit 1;
		
	fi
	
}

clear

URL_BASE="https://statusinvest.com.br"

if [ -f ${FILE_LLS} ]; then

	rm -fv ${FILE_LLS}

fi

set_fiis
set_fiagro
