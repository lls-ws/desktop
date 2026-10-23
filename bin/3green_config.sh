#!/bin/sh
# Script to configure Lubuntu Desktop on 3Green AllInOne
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

check_root "$1"

clear

user_conf()
{
	
	DIR_DELL="/home/${USER}/.dell"

	if [ ! -d "${DIR_DELL}" ]; then
	
		su ${USER} -c "mkdir -pv ${DIR_DELL}"
	
	fi
	
	ls -alh ${DIR_DELL}
	
	echo "Adicionar a configuração no arquivo do sistema:"
	grep -q "dell:/home/shared" /etc/fstab || echo "dell:/home/shared   /home/lls/.dell   nfs   defaults,noatime,x-systemd.automount,bg,timeo=14,x-systemd.idle-timeout=60   0   0" | sudo tee -a /etc/fstab
	
	echo "Aplicar as mudanças sem reiniciar:"
	sudo systemctl daemon-reload && sudo systemctl restart remote-fs.target
	
}

user_clear()
{
	
	echo "Remove Package Manager:"
	rm -rfv /home/lls/.package-manager
	
	echo "Remove Google Default Cache:"
	rm -rfv /home/lls/.config/google-chrome/Default/Cache/* /home/lls/.config/google-chrome/Default/Media\ Cache/*
	
	echo "Remove Google Profile 2 Cache:"
	rm -rfv "/home/lls/.config/google-chrome/Profile 2/Service Worker/CacheStorage/"* "/home/lls/.config/google-chrome/Profile 2/Service Worker/ScriptCache/"*

	echo "Remove Google Profile 3 Cache:"
	rm -rfv "/home/lls/.config/google-chrome/Profile 3/Service Worker/CacheStorage/"* "/home/lls/.config/google-chrome/Profile 3/Service Worker/ScriptCache/"*

	echo "Remover automaticamente todos pacotes com status deinstall:"
	dpkg --get-selections | grep deinstall | awk '{print $1}' | xargs -r sudo apt purge -y
	
	echo "Limpe os pacotes órfãos do sistema:"
	sudo apt autoremove --purge -y

	echo "Limpar completamente o cache de pacotes baixados:"
	sudo apt clean && sudo apt autoclean

	echo "Limpar cache de logs do sistema:"
	sudo journalctl --vacuum-time=3d
	
	sudo update-grub
	
}

apps_install()
{
	
	sudo apt -y install audacious geany qalculate-qt qpdfview pulseaudio-utils streamripper xournalpp
	
}

swap_conf()
{
	
	echo "Aumentar o arquivo de Swap para 4 GB:"
	sudo swapoff -a
	sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
	sudo chmod -v 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
	
	free -h
	
}

swappiness_conf()
{
	
	echo "Ajustar o Swappiness (Evitar lentidão no SSD):"
	echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-custom-swappiness.conf
	
	echo "Aplicar a mudança imediatamente:"
	sudo sysctl --system
	
	echo "Verificar se funcionou:"
	cat /proc/sys/vm/swappiness
	
}

snap_remove()
{
	
	echo "Remover os aplicativos e temas:"
	sudo snap remove --purge firmware-updater gnome-46-2404 gnome-42-2204 gnome-3-28-1804 mesa-2404 gtk-common-themes
	
	echo "Remover as bases e os pacotes complementares:"
	sudo snap remove --purge bare core24 core22 core18
	
	echo "Remover o Snapd:"
	sudo snap remove --purge snapd

	echo "O Comando Definitivo de Limpeza e Bloqueio:"
	sudo apt purge snapd -y && sudo apt autoremove --purge -y && rm -rf ~/snap && sudo rm -rf /var/cache/snapd/ /var/snap/ /var/lib/snapd/ && echo -e "Package: snapd\nPin: release a=*\nPin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap.pref
	
}

apps_remove()
{
	
	echo "Desinstalar Pacotes Inúteis e Pesados:"
	sudo apt purge -y apport apport-gtk whoopsie mariadb-server mariadb-client cups cups-core-drivers cups-daemon speech-dispatcher spice-vdagent
	
	echo "Limpar qualquer resíduo que tenha ficado:"
	sudo apt-get install -f -y
	
	echo "Otimizar os Serviços de Inicialização (Systemd):"
	sudo systemctl disable apport.service

	echo "Se você usa Wi-Fi e não Bluetooth (Economiza RAM do adaptador):"
	sudo systemctl disable bluetooth.service
	
	echo "Desativar switcheroo-control.service:"
	sudo systemctl disable --now switcheroo-control.service
	
	echo "Desativar accounts-daemon.service:"
	sudo systemctl disable --now accounts-daemon.service
	
	echo "Desativar motd-news.timer:"
	sudo systemctl disable --now motd-news.timer
	
	echo "Desativar o Firmware Update Daemon (fwupd.service):"
	sudo systemctl mask fwupd.service

	echo "Remover Drivers de Impressão e Escaneamento (CUPS / SANE):"
	sudo apt purge -y printer-driver-* system-config-printer* hplip* cups-* ipp-usb sane-*

	echo "Remover Ferramentas e Compiladores de Desenvolvimento Redundantes:"
	sudo apt purge -y gcc-13 gcc-13-base gcc-14 gcc-14-base cpp-13 cpp-14 tizenbrew-device-manager

	echo "Remover Jogos:"
	sudo apt purge -y 2048-qt

	echo "Remover Aplicativos Gráficos Utilitários Não Listados:"
	sudo apt purge -y xscreensaver xscreensaver-* onboard onboard-* transmission-common transmission-qt noblenote redshift redshift-qt

	echo "Desativar e Remover o Servidor SSH (openssh-server):"
	sudo systemctl stop ssh.service openssh-server.service 2>/dev/null
	sudo systemctl disable ssh.service openssh-server.service 2>/dev/null
	sudo apt purge openssh-server -y

	echo "Desativar o Servidor NFS e Manter Apenas o Cliente:"
	sudo systemctl disable nfs-server.service 2>/dev/null
	sudo systemctl stop rpcbind.socket
	sudo systemctl disable rpcbind.socket
	sudo systemctl mask rpcbind.socket
	sudo apt purge nfs-kernel-server -y
	
	echo "Desinstalar o maven, o default-jdk e o gerenciador de pacotes secundário aptitude:"
	sudo apt remove --purge -y maven default-jdk default-jdk-headless default-jre default-jre-headless aptitude

	echo "Remover as versões do OpenJDK e NodeJS:"
	sudo apt remove --purge -y openjdk-11-* openjdk-25-* nodejs npm webpack

	echo "Remover Maven, NodeJS, NPM e Frameworks Web"
	sudo apt purge -y maven nodejs npm webpack node-* eslint handlebars

	echo "Eliminar o LibreOffice por Completo:"
	sudo apt purge -y libreoffice* libuno-* uno-libs-private ure ure-java

	echo "Remover o ecossistema TeX / LaTeX residual:"
	sudo apt purge -y texlive-base texlive-binaries lmodern tex-common dvipng dvisvgm

	echo "Faxina Geral de Pacotes Órfãos e Cache (Crucial):"
	sudo apt autoremove --purge -y && sudo apt clean
	
}

USER=`git config user.name`
	
echo "User: ${USER}"
	
if [ -z "${USER}" ]; then

	echo "User not found!"
	exit 1;

fi

case "$1" in
  	install)
		apps_install
		;;
  	conf)
		run_scripts "conf"
		;;
  	user)
		user_conf
		;;
  	bin)
		list_dir "usr/bin"
		;;
  	clear)
		user_clear
		;;
  	swap)
		swap_conf
		;;
  	swappiness)
		swappiness_conf
		;;
  	snap)
		snap_remove
		;;
  	remove)
		apps_remove
		;;
  	terminal)
		terminal_conf
		;;
  	all)
		run_scripts "install"
		run_scripts "conf"
		list_dir "usr/bin"
		user_conf
		swap_conf
		swappiness_conf
		;;
	*)
		echo "Use: $0 {all|install|conf|user|bin|clear|swap|swappiness|snap|remove|terminal}"
		exit 1
		;;
esac
