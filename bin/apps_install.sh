#!/bin/sh
# Script to install apps on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

delete_file() {
	
	if [ -f ${FILE_LIST} ]; then

		rm -fv ${FILE_LIST}

	fi
	
}

echo "Install Essencial Apps..."

DIR_LIST="/etc/apt/sources.list.d"

FILE_LIST="${DIR_LIST}/google.list"

delete_file

echo "Add Google Chrome to sources.list.d"
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --yes --dearmour -o /usr/share/keyrings/google_linux_signing_key.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google_linux_signing_key.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > '${FILE_LIST}''

cat ${FILE_LIST}

FILE_LIST="${DIR_LIST}/opera-stable.list"

delete_file

echo "Add Opera VPN to sources.list.d"
wget -qO- https://deb.opera.com/archive.key | gpg --dearmor | sudo dd of=/usr/share/keyrings/opera-browser.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/opera-browser.gpg] https://deb.opera.com/opera-stable/ stable non-free" > '${FILE_LIST}''

cat ${FILE_LIST}

ls /etc/apt/sources.list.d /usr/share/keyrings

sudo apt update

sudo apt -y install \
	kodi-inputstream-ffmpegdirect \
	kodi-inputstream-adaptive \
	google-chrome-stable \
	kodi-pvr-iptvsimple \
	transmission-daemon \
	nfs-kernel-server \
	opera-stable \
	streamtuner2 \
	streamripper \
	imagemagick \
	pavucontrol \
	ristretto \
	mate-calc \
	audacious \
	mousepad \
	fluxbox \
	lightdm \
	thunar \
	xterm \
	geany \
	curl \
	kodi \
	vlc \
	ssh

sudo apt --only-upgrade install gjs libgjs0g

sudo dpkg-divert --divert /etc/apt/apt.conf.d/20apt-esm-hook.conf.bak --rename --local /etc/apt/apt.conf.d/20apt-esm-hook.conf

ls /etc/apt/apt.conf.d
