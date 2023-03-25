#!/bin/sh
# Script to install apps on Ubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

echo "Install Essencial Apps..."

echo "Add Google Chrome to sources.list.d"
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --yes --dearmour -o /usr/share/keyrings/google_linux_signing_key.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google_linux_signing_key.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'

echo "Add Opera VPN to sources.list.d"
wget -q -O - https://deb.opera.com/archive.key | sudo gpg --yes --dearmour -o /usr/share/keyrings/opera.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/opera.gpg] https://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera.list'

ls /etc/apt/sources.list.d

sudo apt update

sudo apt -y install \
	google-chrome-stable \
	transmission-daemon \
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
	parole \
	thunar \
	xterm \
	geany \
	curl
