#!/bin/sh
# Script to Install and Configure Docker on Dell Ubuntu Server
# Processador: Pentium(R) Dual-Core CPU       T4400  @ 2.20GHz
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

docker_edit()
{
	
	FILE_JELLYFIN="docker-compose.yml"
	
	echo "Editar o arquivo ${FILE_JELLYFIN}"
	sudo nano ~/jellyfin/${FILE_JELLYFIN}
	
}

docker_install()
{
	
	docker_conf
	
	echo "Atualize o sistema:"
	sudo apt-get update
	
	echo "Instale os pacotes do Docker:"
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	
	echo "Permita gerenciar o Docker sem sudo:"
	sudo usermod -aG docker ${USER}
	
	echo "Verificar a instalação:"
	docker run hello-world
	
	jellyfin_conf
	
	docker_version
	
}

docker_conf()
{
	
	echo "Atualize o sistema:"
	sudo apt update
	
	echo "Instale os pacotes de pré-requisito:"
	sudo apt-get install -y ca-certificates curl gnupg

	echo "Adicione a chave GPG oficial do Docker:"
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	
	echo "Remova o repositório estável às fontes do Apt:"
	sudo rm -fv /etc/apt/sources.list.d/docker.list
	
	echo "Adicione o repositório estável às fontes do Apt:"
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

}

jellyfin_conf()
{
	
	USER=`git config user.name`
	
	FILE_SET="${NAME_APP}-compose.yml"
	
	DIR_ETC="/home/${USER}/.jellyfin"
	
	echo "Configure ${NAME_APP}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc"
	
	movies_dir
	
	cat ${DIR_ETC}/${FILE_SET}
	
	echo "Prepare as pastas de dados:"
	sudo mkdir -pv ${DIR_ETC}/{config,cache,media}
	
	sudo chown -R ${USER}:${USER} "${DIR_ETC}"
	
	echo "Iniciando o servidor..."
	(cd ${DIR_ETC}; sudo docker compose up -d)
	
}

docker_version()
{

	${NAME_APP} -v
	
	sudo ${NAME_APP} ps -a
	
	sudo ${NAME_APP} logs jellyfin
	
}

docker_uninstall()
{

	clear
	
	apt -y remove --purge ${NAME_APP}
	
	apt -y autoremove
	
}

tizen_install()
{
	
	echo "Atualizar a Imagem Docker no PC:"
	sudo docker pull ghcr.io/georift/install-jellyfin-tizen:latest
	
	echo "Executar a Nova Instalação:"
	sudo docker run --rm ghcr.io/georift/install-jellyfin-tizen 192.168.0.3
	
}

NAME_APP="docker"

case "$1" in
	install)
		docker_install
		;;
	version)
		docker_version
		;;
	conf)
		jellyfin_conf
		;;
	edit)
		docker_edit
		;;
	tizen)
		tizen_install
		;;
	*)
		echo "Use: $0 {install|version|conf|tizen|edit}"
		exit 1
		;;
esac
