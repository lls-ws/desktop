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
	
	sudo nano /etc/minidocker.conf
	
	docker_conf
	
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
	
	#docker_conf
	
}

docker_conf()
{
	
	docker_version
	
	FILE_SET="${NAME_APP}.conf"
	
	DIR_ETC="etc"
	
	echo "Configure ${NAME_APP}..."
	
	update_file "${FILE_SET}" "/${DIR_ETC}" "${DIR_ETC}"

	shared_dir
	
	cat /${DIR_ETC}/${FILE_SET}
	
	echo 'DAEMON_OPTS="-R"' > /${DIR_ETC}/default/${NAME_APP}
	
	cat /${DIR_ETC}/default/${NAME_APP}
	
	chown -Rv ${NAME_APP}:${NAME_APP} /var/cache/${NAME_APP}
	
	chmod -Rv 775 /var/cache/${NAME_APP}
	
	systemctl disable ${NAME_APP}.service
	
	service ${NAME_APP} force-reload
	
	service ${NAME_APP} status
	
}

docker_version()
{

	${NAME_APP}d -V
	
}

docker_uninstall()
{

	clear
	
	apt -y remove --purge ${NAME_APP}
	
	apt -y autoremove
	
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
		docker_conf
		;;
	edit)
		docker_edit
		;;
	nfs)
		nfs_conf
		;;
	uninstall)
		docker_uninstall
		;;
	*)
		echo "Use: $0 {install|version|conf|uninstall|edit|nfs}"
		exit 1
		;;
esac
