#!/bin/sh
# Script to Install and Configure Docker on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

docker_edit()
{
	
	sudo nano ~/jellyfin/docker-compose.yml
	
}

docker_install()
{
	
	# Remova versões antigas
	sudo apt-get -y remove docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
	
	# Configurar o repositório oficial
	sudo apt-get update
	sudo apt-get -y install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings

	# Adicione a chave GPG oficial da Docker
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	
	# Adicione o repositório às fontes do apt
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	
	# Instalar o Docker Engine
	sudo apt-get update
	sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	
	# Verificar a instalação
	sudo docker run hello-world
	
	# Executar sem sudo
	sudo usermod -aG docker $USER
	
	docker_version
	
	jellyfin_conf
	
}

jellyfin_conf()
{
	
	FILE_SET="${NAME_APP}-compose.yml"
	
	DIR_ETC="/home/$USER/jellyfin"
	
	echo "Configure ${NAME_APP}..."
	
	update_file "${FILE_SET}" "${DIR_ETC}" "etc"
	
	shared_dir
	
	cat ${DIR_ETC}/${FILE_SET}
	
	# Prepare as pastas de dados
	mkdir -pv ${DIR_ETC}/{config,cache,media}
	
	# Inicie o servidor
	(cd ${DIR_ETC}; sudo docker compose up -d)
	
	sudo chown -R $USER:$USER "${DIR_ETC}"
	
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
	
	sudo docker run --rm ghcr.io/georift/install-jellyfin-tizen 192.168.0.170
	
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
	nfs)
		nfs_conf
		;;
	tizen)
		tizen_install
		;;
	*)
		echo "Use: $0 {install|version|conf|tizen|edit|nfs}"
		exit 1
		;;
esac
