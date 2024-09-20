#!/bin/sh
# Script to connect in a cloud with ssh
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

ssh_command()
{

	echo "Connect on cloud: ${DNAME}"
	
	CMD_SSH="ssh -i ${SSH_KEY} -p ${SSH_PORT} ${USER}@${DNAME}"

 	qterminal -e ${CMD_SSH} &
		
}

USER=`git config user.name`

if [ -z "${USER}" ]; then
		
	echo "Not found a user name!"
	echo "Use: git_conf.sh name {NAME}"
	exit 1
	
fi

SSH_PORT="22"
DIR_USER="/home/${USER}"
DIR_SSH="${DIR_USER}/.ssh"
SSH_KEY="${DIR_SSH}/id_rsa"

DNAME="${USER}.net.br"

HOSTNAME="$1"

if [ -z "${HOSTNAME}" ]; then

	echo "Hostname not found!"
	echo "Use: `basename $0` [HOSTNAME]"
	exit 1;
	
else

	DNAME=${HOSTNAME}.${DNAME}

fi

if [ "$2" = "ubuntu" ]; then

	SSH_KEY=`ls ${DIR_SSH}/${USER}-${HOSTNAME}-*.pem | tail -1`
	
	USER="$2"

fi

if [ ! -f "${SSH_KEY}" ]; then
	
	echo "SSH Key File not found!"
	echo "Use: `basename $0` [HOSTNAME] [USER]"
	exit 1;

fi

chmod -v 400 ${SSH_KEY}

ssh_command
