#!/bin/sh
# Script Configure Ubuntu Desktop 22.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

apps_install()
{

	echo "Install Essencial Apps..."
	apt -y install arc arj cabextract lhasa p7zip p7zip-full p7zip-rar rar unrar unace unzip xz-utils zip
	apt -y install ubuntu-restricted-extras
	apt -y install stacer
	
}

browsers_install()
{

	echo "Install Google Chrome..."
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
	cd /tmp && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && cd ..
	
	echo "Install Opera VPN..."
	echo "deb https://deb.opera.com/opera-stable/ stable non-free" | tee /etc/apt/sources.list.d/opera-stable.list
	cd /tmp && wget -q -O - https://deb.opera.com/archive.key | apt-key add - && cd ..
	
	apt update && apt -y install opera-stable google-chrome-stable
	
}

geany_install()
{

	echo "Install Geany..."
	apt -y install geany
	git clone https://github.com/geany/geany-themes.git
	cd geany-themes
	./install.sh
	cd ..
	rm -rf geany-themes
	rm -rf /home/lls/.config/geany/colorschemes
	cp -rf /root/.config/geany/colorschemes /home/lls/.config/geany
	chown -v lls.lls /home/lls/.config/geany/colorschemes
	
	echo "Configure Geany..."
	
	NAME_DIR="geany"
	
	update_file "geany.conf" "/home/lls/.config/${NAME_DIR}" "conf/${NAME_DIR}"
	update_file "keybindings.conf" "/home/lls/.config/${NAME_DIR}" "conf/${NAME_DIR}"
	
}

audacious_install()
{

	echo "Install Audacious..."
	apt -y install audacious
	
	echo "Configure Audacious..."
	
	NAME_DIR="audacious"
	
	update_file "config" "/home/lls/.config/${NAME_DIR}" "conf/${NAME_DIR}"
	update_file "1000.audpl" "/home/lls/.config/${NAME_DIR}/playlists" "conf/${NAME_DIR}/playlists"
	
}

desktop_backup()
{

	echo "Backup Geany..."
	
	NAME_DIR="geany"
	
	update_file "geany.conf" "conf/${NAME_DIR}" "/home/lls/.config/${NAME_DIR}"
	update_file "keybindings.conf" "conf/${NAME_DIR}" "/home/lls/.config/${NAME_DIR}"
	
	echo "Backup Audacious..."
	
	NAME_DIR="audacious"
	
	update_file "config" "conf/${NAME_DIR}" "/home/lls/.config/${NAME_DIR}"
	update_file "1000.audpl" "conf/${NAME_DIR}/playlists" "/home/lls/.config/${NAME_DIR}/playlists"
	
}

update_file()
{

	FILE_CONF="$1"
	
	DIR_CONF="$2"
	DIR_CLOUD="$3"
	
	if [ ! -d ${DIR_CONF} ]; then
	
		mkdir -pv ${DIR_CONF}
		chown -v lls.lls ${DIR_CONF}
	
	fi
	
	echo "Copy File Configuration..."
	rm -fv ${DIR_CONF}/${FILE_CONF}
	
	cp -fv ${DIR_CLOUD}/${FILE_CONF} ${DIR_CONF}
	
	chown -v lls.lls ${DIR_CONF}/${FILE_CONF}
	
}

if [ `id -u` -ne 0 ]; then
	echo "Run script as root"
	exit 1
fi

case "$1" in
	install)
		apps_install
		;;
	browsers)
		browsers_install
		;;
	geany)
		geany_install
		;;
	audacious)
		audacious_install
		;;
	backup)
		desktop_backup
		;;
	all)
		apps_install
		browsers_install
		geany_install
		audacious_install
		;;
	*)
		echo "Use: $0 {all|install|browsers|geany|audacious|backup}"
		exit 1
		;;
esac
