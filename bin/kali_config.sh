#!/bin/sh
# Script Configure Kali Linux
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

kali_upgrade()
{
	
	echo "Update Kali..."
	apt-get update
	apt-get upgrade
	apt-get dist-upgrade
	apt-get auto-remove
	
}

kali_locale()
{
	
	locale-gen pt_BR.UTF-8
	
	dpkg-reconfigure locales
	
	update-locale LANG=pt_BR.UTF-8
	
	cat /etc/default/locale
	
}

kali_hosts()
{
	
	echo "127.0.0.1			localhost" 					> /etc/hosts
	echo "192.168.15.1		router.lls.net.br		router"		>> /etc/hosts
	echo "192.168.15.150		repeater.lls.net.br		repeater" 	>> /etc/hosts
	echo "192.168.15.160		samsung.lls.net.br		samsung" 	>> /etc/hosts
	echo "192.168.15.170		dell.lls.net.br			dell" 		>> /etc/hosts
	echo "192.168.15.180		motorola.lls.net.br		motorola" 	>> /etc/hosts
	echo "192.168.15.190		xiaomi.lls.net.br		xiaomi"		>> /etc/hosts
	echo "192.168.15.200		asus.lls.net.br			asus" 		>> /etc/hosts
	echo "208.67.222.222		opendns.lls.net.br		opendns" 	>> /etc/hosts
	echo "208.67.220.220		opendns2.lls.net.br		opendns2" 	>> /etc/hosts
	
	cat /etc/hosts
	
}

wifi_install()
{

	# Install Broadcom Firmware
	apt-get install broadcom-sta-dkms
	modprobe -r b44 b43 b43legacy ssb brcmsmac bcma
	modprobe wl

}

user_config()
{

	# Mount Windows Partition
	echo "/dev/sda3 /mnt/windows ntfs rw,auto 0 0" >> /etc/fstab
	mkdir -v /mnt/windows
	mount /mnt/windows

	# Create folders links for user
	rmdir -v /home/lls/Downloads /home/lls/Documentos /home/lls/Imagens /home/lls/Musica /home/lls/Videos /home/lls/Modelos /home/lls/Público

	ln -sv /mnt/windows/Downloads /home/lls/
	ln -sv /mnt/windows/Documentos /home/lls/
	ln -sv /mnt/windows/Imagens /home/lls/
	ln -sv /mnt/windows/Musicas /home/lls/
	ln -sv /mnt/windows/Videos /home/lls/
	ln -sv /mnt/windows/Projetos /home/lls/
	
}

chrome_install()
{

	# Install Google Chrome
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

	apt-get update
	apt-get install google-chrome-stable
	apt-get install --no-install-recommends gnome-panel

}

teamviewer_install()
{

	# Install Teamviewer
	echo "deb http://linux.teamviewer.com/deb stable main" | tee /etc/apt/sources.list.d/teamviewer.list

	sudo apt -y install gpg ca-certificates
	
	wget -O - https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc | sudo apt-key add -

	apt-get update
	apt-get install teamviewer

}

seamonkey_install()
{

	# Install Seamonkey
	cat <<EOF | tee /etc/apt/sources.list.d/mozilla.list
deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main
EOF

	apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2667CA5C
	apt-get update
	apt-get install seamonkey-mozilla-build
	
}

geany_install()
{

	# Install Geany
	apt-get -y install geany
	git clone https://github.com/geany/geany-themes.git
	cd geany-themes
	./install.sh
	cd ..
	rm -rf geany-themes
	rm -rf /home/lls/.config/geany/colorschemes
	cp -rf /root/.config/geany/colorschemes /home/lls/.config/geany
	chown lls.lls /home/lls/.config/geany/colorschemes
	
}

apps_install()
{

	# Install Essencial Apps
	apt-get -y install fluxbox transmission-daemon streamtuner2 streamripper mcedit iptables-persistent gtk-theme-switch imagemagick mariadb-server openjdk-11-jdk-headless lynx ttf-mscorefonts-installer chromium filezilla audacious vlc gimp kodi kodi-inputstream-adaptive
	
}

kali_install()
{
	
	DIR_CONF="/home/lls/Projetos/kali/config"
	
	# ssh config
	rm -rfv /home/lls/.ssh
	cp -rfv ${DIR_CONF}/ssh /home/lls/.ssh
	chown -Rv lls.lls /home/lls/.ssh
	chmod -Rv 700 /home/lls/.ssh
	ls -al /home/lls/.ssh
	
	# gtk-3.0 config
	rm -fv /home/lls/.config/gtk-3.0/settings.ini
	cp -fv ${DIR_CONF}/gtk-3.0/settings.ini /home/lls/.config/gtk-3.0
	chown lls.lls /home/lls/.config/gtk-3.0/settings.ini
	
	# streamtuner2 config
	rm -fv /home/lls/.config/streamtuner2/settings.json
	cp -fv ${DIR_CONF}/streamtuner2/settings.json /home/lls/.config/streamtuner2
	chown lls.lls /home/lls/.config/streamtuner2/settings.json
	
	# transmission config
	rm -fv /root/.config/transmission-daemon/settings.json
	cp -fv ${DIR_CONF}/transmission-daemon/settings.json /root/.config/transmission-daemon
	chown root.root /root/.config/transmission-daemon/settings.json
	
	# geany config
	rm -fv /home/lls/.config/geany/geany.conf
	rm -fv /home/lls/.config/geany/keybindings.conf
	
	cp -fv ${DIR_CONF}/geany/geany.conf /home/lls/.config/geany
	cp -fv ${DIR_CONF}/geany/keybindings.conf /home/lls/.config/geany
	
	chown lls.lls /home/lls/.config/geany/geany.conf
	chown lls.lls /home/lls/.config/geany/keybindings.conf
	
	# fluxbox config
	rm -fv /home/lls/.fluxbox/apps
	rm -fv /home/lls/.fluxbox/menu
	rm -fv /home/lls/.fluxbox/keys
	rm -fv /home/lls/.fluxbox/init
	rm -fv /home/lls/.fluxbox/startup
	rm -rfv /home/lls/.fluxbox/pixmaps
	
	cp -fv ${DIR_CONF}/fluxbox/apps /home/lls/.fluxbox
	cp -fv ${DIR_CONF}/fluxbox/menu /home/lls/.fluxbox
	cp -fv ${DIR_CONF}/fluxbox/keys /home/lls/.fluxbox
	cp -fv ${DIR_CONF}/fluxbox/init /home/lls/.fluxbox
	cp -fv ${DIR_CONF}/fluxbox/startup /home/lls/.fluxbox
	cp -rfv ${DIR_CONF}/fluxbox/pixmaps /home/lls/.fluxbox
	
	chown lls.lls /home/lls/.fluxbox/apps
	chown lls.lls /home/lls/.fluxbox/menu
	chown lls.lls /home/lls/.fluxbox/keys
	chown lls.lls /home/lls/.fluxbox/init
	chown lls.lls /home/lls/.fluxbox/startup
	chown lls.lls /home/lls/.fluxbox/pixmaps
	
}

kali_backup()
{
	
	DIR_CONF="/home/lls/Projetos/kali/config"
	
	# gtk-3.0 config
	cp -fv /home/lls/.config/gtk-3.0/settings.ini ${DIR_CONF}/gtk-3.0
	
	# streamtuner2 config
	cp -fv /home/lls/.config/streamtuner2/settings.json ${DIR_CONF}/streamtuner2
	
	# geany config
	cp -fv /home/lls/.config/geany/geany.conf ${DIR_CONF}/geany
	cp -fv /home/lls/.config/geany/keybindings.conf ${DIR_CONF}/geany
	
	# fluxbox config
	cp -fv /home/lls/.fluxbox/apps ${DIR_CONF}/fluxbox
	cp -fv /home/lls/.fluxbox/menu ${DIR_CONF}/fluxbox
	cp -fv /home/lls/.fluxbox/keys ${DIR_CONF}/fluxbox
	cp -fv /home/lls/.fluxbox/init ${DIR_CONF}/fluxbox
	cp -fv /home/lls/.fluxbox/startup ${DIR_CONF}/fluxbox
	cp -fv /home/lls/.fluxbox/pixmaps/*.xpm ${DIR_CONF}/fluxbox/pixmaps
	
	# Create a backup file
	create_file
	
}

kali_links()
{
	
	DIR_SH="/home/lls/Projetos/kali/sh"
	
	ln -sfv ${DIR_SH}/cloud_connect.sh 	/usr/bin/cloud_connect
	ln -sfv ${DIR_SH}/print_screen.sh 	/usr/bin/print_screen
	ln -sfv ${DIR_SH}/kali_config.sh 	/usr/bin/kali_config
	ln -sfv ${DIR_SH}/terminal.sh 		/usr/bin/terminal
	ln -sfv ${DIR_SH}/crack.sh 			/usr/bin/crack
	ln -sfv ${DIR_SH}/brilho.sh 		/usr/bin/brilho
	
	## Create symlink for java jre
	## update-alternatives --config java
	
	rm -fv /usr/lib/jvm/jre
	ln -sfv /usr/lib/jvm/default-java /usr/lib/jvm/jre
	
}

grub_conf()
{
	
	echo "Configuring grub..."
	
	IMG_PNG="images/wallpaper.png"
	IMG_SVG="images/wallpaper.svg"
	
	cp -fv ${IMG_PNG} /boot/grub/themes/kali/background.png
	cp -fv ${IMG_PNG} /boot/grub/themes/kali/grub-4x3.png
	cp -fv ${IMG_PNG} /boot/grub/themes/kali/grub-16x9.png
	
	cp -fv ${IMG_SVG} /usr/share/images/desktop-base/login-background.svg
	cp -fv ${IMG_PNG} /usr/share/images/desktop-base/login-background.png
	cp -fv ${IMG_PNG} /usr/share/images/desktop-base/desktop-grub.png
	cp -fv ${IMG_PNG} /usr/share/backgrounds/kali/kali-light-16x9.png
	
	cp -fv ${IMG_SVG} /usr/share/desktop-base/kali-theme/login/background.svg
	cp -fv ${IMG_SVG} /usr/share/desktop-base/kali-theme/login/background
	cp -fv ${IMG_PNG} /usr/share/desktop-base/kali-theme/wallpaper/contents/images/3840x2160.png
	cp -fv ${IMG_PNG} /usr/share/desktop-base/kali-theme/wallpaper/contents/images/2560x1600.png
	cp -fv ${IMG_PNG} /usr/share/desktop-base/kali-theme/wallpaper/contents/images/1600x1200.png
	cp -fv ${IMG_PNG} /usr/share/desktop-base/kali-theme/grub/grub-4x3.png
	cp -fv ${IMG_PNG} /usr/share/desktop-base/kali-theme/grub/grub-16x9.png
	
	echo "GRUB_BACKGROUND='/usr/share/images/desktop-base/login-background.png'" >> /etc/default/grub
	
	sed -i 's/Light/Dark/g' /etc/lightdm/lightdm-gtk-greeter.conf
	
	update-grub
	
}

ssh_conf()
{
	
	systemctl start ssh.socket
	
	systemctl enable ssh.service
	
	systemctl status ssh.service
	
}

iptables_install()
{

	apt-get remove ufw
	
	systemctl mask ufw
	systemctl disable ufw
	
	RULES="/etc/iptables/rules.v4"
	
	echo "*filter"																		> ${RULES}
	echo ":INPUT ACCEPT [0:0]"															>> ${RULES}
	echo ":FORWARD ACCEPT [0:0]"														>> ${RULES}
	echo ":OUTPUT ACCEPT [0:0]"															>> ${RULES}
	echo "COMMIT"																		>> ${RULES}
	
	echo "*nat"																			>> ${RULES}
	echo ":PREROUTING ACCEPT [0:0]"														>> ${RULES}
	echo ":INPUT ACCEPT [0:0]"															>> ${RULES}
	echo ":POSTROUTING ACCEPT [0:0]"													>> ${RULES}
	echo ":OUTPUT ACCEPT [0:0]"															>> ${RULES}
	echo "-A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080"			>> ${RULES}
	echo "-A PREROUTING -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 8443"			>> ${RULES}
	echo "-I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080"				>> ${RULES}
	echo "-I OUTPUT -p tcp -o lo --dport 443 -j REDIRECT --to-ports 8443"				>> ${RULES}
	
	echo "COMMIT"																		>> ${RULES}
	
	iptables-restore -n < ${RULES}
	
	cat ${RULES}
	
	RULES="/etc/sysctl.conf"
	
	echo "net.ipv4.ip_forward=1" >> ${RULES}
	
	cat ${RULES}
	
	systemctl enable iptables
	
	service iptables start
	
	service iptables status
	
}

nfs_conf()
{
	
	apt install -y nfs-kernel-server
	
	systemctl enable nfs-kernel-server
	
	EXPORTS="/etc/exports"
	
	echo "/mnt/windows/Documentos *(rw,sync,root_squash,subtree_check)" 									> ${EXPORTS}
	echo "/mnt/windows/Downloads *(rw,sync,root_squash,subtree_check)" 										>> ${EXPORTS}
	echo "/mnt/windows/Imagens *(rw,sync,root_squash,subtree_check)" 										>> ${EXPORTS}
	echo "/mnt/windows/Projetos *(rw,sync,root_squash,subtree_check)" 										>> ${EXPORTS}
	echo "/mnt/windows/Videos *(rw,fsid=0,sync,insecure_locks,insecure,no_root_squash,subtree_check)"		>> ${EXPORTS}
	echo "/mnt/windows/Musicas *(rw,fsid=0,sync,insecure_locks,insecure,no_root_squash,subtree_check)"		>> ${EXPORTS}
	
	cat ${EXPORTS}
	
	exportfs -rav
	
	systemctl restart nfs-kernel-server
	
}

rc_local()
{
	
	RC_LOCAL="/etc/rc.local"
	
	IP="192.168.0.170"
	
	echo "#!/bin/sh"					> ${RC_LOCAL}
	echo "#run scripts here"			>> ${RC_LOCAL}
	echo "exit 0"						>> ${RC_LOCAL}
	
	cat ${RC_LOCAL}
	
	chmod 755 ${RC_LOCAL}
	
	SERVICE="/etc/systemd/system/rc-local.service"
	
	echo "[Unit]" 										> ${SERVICE}
	echo " Description=${RC_LOCAL} Compatibility" 		>> ${SERVICE}
	echo " ConditionPathExists=${RC_LOCAL}"	 			>> ${SERVICE}
	echo " "											>> ${SERVICE}
	echo "[Service]" 									>> ${SERVICE}
	echo " Type=forking"								>> ${SERVICE}
	echo " ExecStart=${RC_LOCAL}"						>> ${SERVICE}
	echo " TimeoutSec=0"								>> ${SERVICE}
	echo " StandardOutput=tty"							>> ${SERVICE}
	echo " RemainAfterExit=yes"							>> ${SERVICE}
	echo " SysVStartPriority=99"						>> ${SERVICE}
	echo " "											>> ${SERVICE}
	echo "[Install]"									>> ${SERVICE}
	echo " WantedBy=multi-user.target"					>> ${SERVICE}
	
	cat ${SERVICE}
	
	systemctl enable rc-local.service
	
	systemctl start rc-local.service
	
	systemctl status rc-local.service
	
	
}

lan_redirect()
{
	
	#sudo sysctl -w net.ipv4.ip_forward=1
	#sudo cat /proc/sys/net/ipv4/ip_forward
	#sudo iptables -A FORWARD --in-interface eth0 -j ACCEPT
	#sudo iptables --table nat -A POSTROUTING --out-interface wlan1 -j MASQUERADE
	
	
	# Enable forwarding on your linux box:
	# Allow specific (or all of it) packets to traverse your router
	# As someone stated, as netfilter is a stateless firewall, allow traffic for already established connections
	# Change the source address on packets going out to the internet

	

	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -A FORWARD -i eth0 -o wlan1 -j ACCEPT
	iptables -A FORWARD -i wlan1 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
	iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE

}

wifi_disable()
{

	echo "Shows the names of the modules:"
	ls -d /sys/module/cfg80211/holders/*/drivers | cut -d/ -f6
	
	echo "blacklist wl" > /etc/modprobe.d/local.conf
	
	cat /etc/modprobe.d/local.conf
	
	update-initramfs -u
	
	reboot
	
}

if [ `id -u` -ne 0 ]; then
	echo "Run script as root"
	exit 1
fi

case "$1" in
	wifi)
		#wifi_install
		wifi_disable
		;;
	user)
		user_config
		;;
	browser)
		chrome_install
		#seamonkey_install
		#teamviewer_install
		;;
	geany)
		geany_install
		;;
	apps)
		apps_install
		;;
	upgrade)
		kali_upgrade
		;;
	locale)
		kali_locale
		;;
	hosts)
		kali_hosts
		;;	
	install)
		kali_install
		;;
	backup)
		kali_backup
		;;
	links)
		kali_links
		;;
	grub)
		grub_conf
		;;
	ssh)
		ssh_conf
		;;
	nfs)
		nfs_conf
		;;
	iptables)
		iptables_install
		;;
	rc_local)
		rc_local
		;;
	all)
		kali_upgrade
		wifi_install
		user_config
		chrome_install
		geany_install
		apps_install
		kali_install
		kali_links
		kali_locale
		kali_hosts
		grub_conf
		ssh_conf
		nfs_conf
		;;
	*)
		echo "Use: $0 {all|upgrade|install|backup|links|locale|hosts|wifi|user|browser|geany|apps|grub|ssh|nfs|iptables|rc_local}"
		exit 1
		;;
esac
