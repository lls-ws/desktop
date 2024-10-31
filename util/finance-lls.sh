#!/bin/sh
# Script to get Real Estate Funds Quotes
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

set_edit()
{
	
	geany ${DIR_LLS}/*.txt &
	
}

check_dir()
{
	
	DIR_LLS=~/.`basename ${0%.*}`
	
	echo "DIR_LLS: ${DIR_LLS}"
	
	if [ ! -d ${DIR_LLS} ]; then
	
		mkdir -v ${DIR_LLS}
		
	fi
	
}

check_file_fiis()
{
	
	set_fiis
	
	check_file
	
}

check_file_fiagro()
{
	
	set_fiagro
	
	check_file
	
}

check_file()
{
	
	FILE_TICKER=${DIR_LLS}/${FUND_TYPE}.txt
	
	if [ ! -f ${FILE_TICKER} ]; then
		
		touch ${FILE_TICKER}
		
	fi
	
	echo "Organize Data in File: ${FILE_TICKER}"
	
	sort -o ${FILE_TICKER} ${FILE_TICKER}
	
}

get_fiis()
{

	check_file_fiis
	
	get_htmls
	
}

get_fiagro()
{

	check_file_fiagro
	
	get_htmls
	
}

set_fiis()
{

	FUND_TYPE="fundos-imobiliarios"
	
}

set_fiagro()
{

	FUND_TYPE="fiagros"
	
}

get_htmls()
{

	FILE_FUND=~/${FUND_TYPE}.csv
	
	if [ -f ${FILE_FUND} ]; then

		rm -fv ${FILE_FUND}

	fi

	echo "Read file: ${FILE_TICKER}"

	while read TICKER
	do
		
		get_html
		
	done < ${FILE_TICKER}
	
	rm -fv /tmp/*.html
	
	echo -e "\nShowing File: ${FILE_FUND}"
	
	cat ${FILE_FUND}
}

get_html()
{

	FILE_HTML="/tmp/${TICKER}.html"
	
	if [ -f ${FILE_HTML} ]; then

		rm -fv ${FILE_HTML}

	fi
	
	URL_TICKER=${URL_BASE}/${FUND_TYPE}/${TICKER}
	
	echo -e "\nTICKER: ${TICKER}"
	echo "TYPE: ${FUND_TYPE}"
	echo "HTML: ${FILE_HTML}"
	echo "URL: ${URL_TICKER}"
	
	wget ${URL_TICKER} -O ${FILE_HTML}
	
	if [ -f ${FILE_HTML} ]; then
	
		get_price
		get_vp
		get_yield
		get_pvp
		get_revenue
		
	fi
	
}

get_price()
{

	PRICE=`cat ${FILE_HTML} | grep -A 3 'Valor atual do ativo' | tail -1 | cut -d '>' -f 2 | cut -d '<' -f 1`
	
	check_value "Price" "${PRICE}"
	
}

get_vp()
{

	VP=`cat ${FILE_HTML} | grep -A 2 'Val. patrimonial p/cota' | tail -1 | cut -d '>' -f 2 | cut -d '<' -f 1`
	
	check_value "VP" "${VP}"
	
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
	
	echo "${PRICE};${VP};${YIELD}%;${PVP};${REVENUE}" >> ${FILE_FUND}
	
}

check_value()
{
	
	TEXT="$1"
	VALUE="$2"
	
	if [ -n "${VALUE}" ]; then
	
		echo "${TEXT}: ${VALUE}"
	
	else
	
		echo "${TEXT} not found!"
		exit 1;
		
	fi
	
}

clear

URL_BASE="https://statusinvest.com.br"

check_dir

case "$1" in
	fiis)
		get_fiis
		;;
	fiagro)
		get_fiagro
		;;
	edit)
		set_edit
		;;
	all)
		get_fiis
		get_fiagro
		;;
	*)
		echo "Use: $0 {all|fiis|fiagro|edit}"
		exit 1
		;;
esac
