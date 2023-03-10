#!/bin/sh
# Script Configure Ubuntu Desktop 22.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

apps_install()
{

	# Install Essencial Apps
	apt -y install arc arj cabextract lhasa p7zip p7zip-full p7zip-rar rar unrar unace unzip xz-utils zip
	apt -y install ubuntu-restricted-extras
	apt -y install audacious
	apt -y install stacer
	
}

browsers_install()
{

	# Install Google Chrome
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
	cd /tmp && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && cd ..
	
	# Install Opera VPN
	echo "deb https://deb.opera.com/opera-stable/ stable non-free" | tee /etc/apt/sources.list.d/opera-stable.list
	cd /tmp && wget -q -O - https://deb.opera.com/archive.key | apt-key add - && cd ..
	
	apt update && apt -y install opera-stable google-chrome-stable
	
}

geany_install()
{

	# Install Geany
	apt -y install geany
	git clone https://github.com/geany/geany-themes.git
	cd geany-themes
	./install.sh
	cd ..
	rm -rf geany-themes
	rm -rf /home/lls/.config/geany/colorschemes
	cp -rf /root/.config/geany/colorschemes /home/lls/.config/geany
	chown -v lls.lls /home/lls/.config/geany/colorschemes
	
	# Configure Geany
	update_file "geany.conf" "/home/lls/.config/geany" "conf/geany"
	update_file "keybindings.conf" "/home/lls/.config/geany" "conf/geany"
	
}

desktop_backup()
{

	# Backup Geany
	update_file "geany.conf" "conf/geany" "/home/lls/.config/geany"
	update_file "keybindings.conf" "conf/geany" "/home/lls/.config/geany"
	
}

update_file()
{

	FILE_CONF="$1"
	
	DIR_CONF="$2"
	DIR_CLOUD="$3"
	
	# Copy File Configuration
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
	backup)
		desktop_backup
		;;
	all)
		apps_install
		browsers_install
		geany_install
		;;
	*)
		echo "Use: $0 {all|install|browsers|geany|backup}"
		exit 1
		;;
esac
