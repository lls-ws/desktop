#!/bin/sh
# Script to configure LLS Profile Desktop on Notebook Dell Inspiron 1428
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1

clear

wifi_config()
{
	
	sudo apt -y purge broadcom-sta-dkms
	sudo rm -fv /etc/modprobe.d/broadcom-sta-dkms.conf
	sudo apt update
	sudo apt -y install firmware-b43-installer
	sudo modprobe -r b43 ssb
	sudo modprobe b43
	lspci -nnk | grep -iA3 net
	ping -c 3 google.com
	
}

apps_install()
{
	
	sudo apt -y install audacious geany qalculate-qt qpdfview pulseaudio-utils
	
}

video_config()
{
	
	echo "Verificar se o driver está ativo: i915"
	lspci -k | grep -A 2 -i vga

	echo "Install Mesa Utils:"
	sudo apt install mesa-utils -y

	echo "Suporte de aceleração 3D e renderização via Mesa (OpenGL):"
	glxinfo | grep -E "OpenGL|renderer"

	sudo mkdir -p /etc/X11/xorg.conf.d/ && echo -e 'Section "Device"\n    Identifier "Intel Graphics"\n    Driver "intel"\n    Option "AccelMethod" "uxa"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf

	sudo cat /etc/X11/xorg.conf.d/20-intel.conf
	
}

git_config()
{
	
	check_cloud
	
	sudo bin/git_conf.sh name "lls"
	sudo bin/git_conf.sh email "lls.home.office@gmail.com"

	sudo bin/git_conf.sh show

	cd ${DIR_LLS}/desktop

	sudo rm -rf ${DIR_LLS}/cloud
	
}

dell_disable()
{
	
	echo "Remover serviços invisíveis:"
	sudo apt -y purge cups cups-browsed cups-daemon cups-core-drivers apport apport-gtk samba-common cups-pk-helper avahi-daemon mdns-scan
	
	
	echo "Limpeza profunda do sistema:"
	sudo apt autoremove --purge -y
	sudo apt clean
	rm -rf ~/.cache/*
	
}

case "$1" in
  	wifi)
		wifi_config
		;;
	apps)
		apps_install
		;;
	video)
		video_config
		;;
	git)
		git_config
		;;
	all)
		wifi_config
		apps_install
		video_config
		git_config
		;;
	*)
		echo "Use: $0 {all|wifi|apps|video|git}"
		exit 1
		;;
esac
