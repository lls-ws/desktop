#!/bin/sh
# Script to connect in a cloud with ssh
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

ssh_command()
{

	echo "Connect on cloud: ${DNAME}"
	
	CMD_SSH="ssh -i ${SSH_KEY} -p ${SSH_PORT} ${USER_SSH}@${DNAME}"
	
	echo "Command: ${CMD_SSH}"
	
	change_scheme
	
	qterminal -e "${CMD_SSH}" 2>/dev/null &
	
}
	
change_scheme()
{

	COLOR_SCHEME="WhiteOnBlack"
	
 	if [ "${HOSTNAME}" = "dell" ]; then
 	
		COLOR_SCHEME="GreenOnBlack"
		
	fi
 	
 	sed -i "s/^colorScheme=.*/colorScheme=${COLOR_SCHEME}/" ~/.config/qterminal.org/qterminal.ini

}
	
ssh_clear()
{
	
	echo "Cleanning known_hosts: ${DNAME}"
	
	FILE_HOSTS=~/.ssh/known_hosts
			
	ssh-keygen -f ${FILE_HOSTS} -R ${DNAME}
			
	chown -v ${USER}:${USER} ${FILE_HOSTS}
	
	change_scheme
	
	ssh -i ${SSH_KEY} -p ${SSH_PORT} ${USER_SSH}@${DNAME}
	
}

SSH_PORT="22"
USER_SSH=$USER
DIR_SSH="/home/$USER/.ssh"
SSH_KEY="${DIR_SSH}/id_rsa"

DNAME="$USER.net.br"

HOSTNAME="$1"

if [ -z "${HOSTNAME}" ]; then

	echo "Hostname not found!"
	echo "Use: `basename $0` [HOSTNAME]"
	exit 1;
	
else

	DNAME=${HOSTNAME}.${DNAME}

fi

if [ "$2" = "ubuntu" ]; then

	SSH_KEY=`ls ${DIR_SSH}/$USER-${HOSTNAME}-*.pem | tail -1`
	
	USER_SSH="$2"

fi

if [ ! -f "${SSH_KEY}" ]; then
	
	echo "SSH Key File not found!"
	echo "Use: `basename $0` [HOSTNAME] [USER_SSH]"
	exit 1;

fi

chmod -v 400 ${SSH_KEY}
chown -v lls:lls ${SSH_KEY}

case "$2" in
	clear)
		ssh_clear
		;;
	*)
		ssh_command
		;;
esac
