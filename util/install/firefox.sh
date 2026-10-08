#!/bin/sh
# Script to Install and Configure Firefox on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

firefox_release()
{
	
	URL_RELEASE="https://product-details.mozilla.org/1.0/firefox_versions.json"
	
	wget -O ${NAME_APP}.json ${URL_RELEASE}
	
	VERSION_FILE=`cat ${NAME_APP}.json | grep "LATEST_FIREFOX_VERSION" | cut -d ':' -f 2 | cut -d '"' -f 2 | cut -d '"' -f 1`
	
	rm -fv ${NAME_APP}.json
	
	echo "Release: ${VERSION_FILE}"
	
}

firefox_install()
{

	echo "Criando diretório para armazenar chaves APT:"
	sudo install -d -m 0755 /etc/apt/keyrings
	
	echo "Importe a chave de assinatura do repositório APT da Mozilla:"
	wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
 	
	echo "Adicionando repositório APT da Mozilla:"
	sudo tee /etc/apt/sources.list.d/mozilla.sources > /dev/null << EOF
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

	echo "Configure o APT prioridade a pacotes do repositório da Mozilla:"
	sudo tee /etc/apt/preferences.d/mozilla > /dev/null << EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

	echo "Atualizando APT:"
	sudo apt-get update

	echo "Instalando ${NAME_APP}"
	sudo apt-get -y install firefox firefox-l10n-pt-br
		
 	firefox_version
	
}

firefox_version()
{

	VERSION_FILE=`${NAME_APP} --version`
	
	echo "Version: ${VERSION_FILE}"
	
}

NAME_APP="firefox"

case "$1" in
	install)
		firefox_install
		;;
	version)
		firefox_version
		;;
	release)
		firefox_release
		;;
	*)
		echo "Use: $0 {install|release|version}"
		exit 1
		;;
esac
