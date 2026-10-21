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
	
	USER=`git config user.name`
	
	echo "User: ${USER}"
	
	if [ ! -z "${USER}" ]; then
		
		su ${USER} -c "bash util/user/config.sh all"
		su ${USER} -c "bash util/user/aliases.sh all"
		su ${USER} -c "bash util/user/screensaver.sh conf"
		su ${USER} -c "bash util/user/lxqt.sh all"
		su ${USER} -c "bash util/user/kodi.sh all"
		
		sudo bash util/install/ytmusic.sh config
		
	fi

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
	
}

case "$1" in
  	install)
		run_scripts "install"
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
  	all)
		run_scripts "install"
		run_scripts "conf"
		list_dir "usr/bin"
		user_conf
		;;
	*)
		echo "Use: $0 {all|install|conf|user|bin|clear}"
		exit 1
		;;
esac
