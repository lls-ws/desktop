#!/bin/sh
# Script to Install and Configure VLC on Lubuntu Desktop
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. lib/update.lib	|| exit 1

check_root "$1"

vlc_update()
{
	
	echo "Update your package lists"
	apt update
	
}

vlc_remove()
{
	
	echo "Removes VLC and its dependencies"
	apt -y remove --autoremove ${NAME_APP}*
	
	echo "Removing Personal Package Archives (PPA)"
	add-apt-repository --remove ppa:videolan/master-daily
	
	vlc_update
	
}

vlc_ppa()
{
	
	echo "Adding Personal Package Archives (PPA)"
	
	add-apt-repository ppa:videolan/master-daily
	
	vlc_update
	
	vlc_release
	
}

vlc_release()
{
	
	apt -a show ${NAME_APP}
	
}

vlc_install()
{

	apt -y install ${NAME_APP}
	
 	vlc_version
	
}

vlc_reset()
{
	
	su lls -c "${NAME_APP} --reset-config ${NAME_APP}://quit"
	
}

vlc_version()
{

	su lls -c "${NAME_APP} --version"
	
}

NAME_APP="vlc"

case "$1" in
	install)
		vlc_install
		;;
	version)
		vlc_version
		;;
	release)
		vlc_release
		;;
	remove)
		vlc_remove
		;;
	reset)
		vlc_reset
		;;
	ppa)
		vlc_ppa
		;;
	*)
		echo "Use: $0 {install|release|remove|reset|version|ppa}"
		exit 1
		;;
esac
