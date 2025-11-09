#!/bin/bash
# Script to Create a Compress File Release
#
# email: lls.homeoffice@gmail.com

if [ "$EUID" -ne 0 ]; then
	
	echo "Run script with sudo command!"
	echo "Use: sudo `basename $0`"
	exit 1
  
fi

USER=`git config user.name`
USER_DIR="/home/${USER}"
REPOSITORY_NAME="$1"
REPOSITORY_DIR="${USER_DIR}/${REPOSITORY_NAME}"
RELESEASE="$2"

REPOSITORIES=(
	"iptv"
	"cloud"
	"desktop"
	"lls-src"
)

git_create()
{
	
	clear
	
	echo "Creating ${REPOSITORY_NAME}.v${RELESEASE}.tar.gz"
	
	RELESEASE_FILE="${REPOSITORY_NAME}-v${RELESEASE}.tar.gz"
	
	if [ -f ${USER_DIR}/${RELESEASE_FILE} ]; then
	
		rm -fv ${USER_DIR}/${RELESEASE_FILE}
	
	fi
	
	(cd ${USER_DIR} ; tar -zcvf ${RELESEASE_FILE} ${REPOSITORY_NAME}; cd -)
	
	if [ ! -f ${USER_DIR}/${RELESEASE_FILE} ]; then
	
		echo "Error creating ${RELESEASE_FILE}"
		exit 1
	
	fi
	
	du -hsc ${USER_DIR}/${RELESEASE_FILE}
	
}

if [[ " ${REPOSITORIES[*]} " =~ " ${REPOSITORY_NAME} " ]]; then

	if [ ! -d ${REPOSITORY_DIR} ]; then
	
		echo "Repository ${REPOSITORY_DIR} not found!"
		echo "Type: git_clone_${REPOSITORY_NAME}"
		exit 1
	
	fi
	
	if [ -z "${RELESEASE}" ]; then
	
		echo "Release not found!"
		echo "Type: sudo $(basename $0) ${REPOSITORY_NAME} [RELESEASE]"
		exit 1
	
	fi
	
	git_create

else

	echo "Repository not found!"
	echo "Type: sudo $(basename $0) [${REPOSITORIES[@]}] [RELESEASE]"
	exit 1

fi
