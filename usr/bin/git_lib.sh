#!/bin/bash
# Script to Update Github Repositories
#
# email: lls.homeoffice@gmail.com

git_error()
{
	
	echo "Repository not found!"
	echo "Type: sudo $(basename $0) [${REPOSITORIES[@]}]"
	exit 1
	
}

git_error_dir()
{
	
	echo "Repository ${REPOSITORY_DIR} not found!"
	echo "Type: sudo git_download.sh ${REPOSITORY_NAME}"
	exit 1
	
}

git_error_find_dir()
{
	
	echo "Repository ${REPOSITORY_DIR} found!"
	exit 1
	
}

git_check()
{
	
	OPTION="$1"
	
	if [[ " ${REPOSITORIES[*]} " =~ " ${REPOSITORY_NAME} " ]]; then

		if [[ ! -d ${REPOSITORY_DIR} && "${OPTION}" != "clone" ]]; then
		
			git_error_dir
			
		fi
		
		if [[ -d ${REPOSITORY_DIR} && "${OPTION}" == "clone" ]]; then
		
			git_error_find_dir
		
		fi
		
		git_${OPTION}

	else

		git_error

	fi
	
}

if [ "$EUID" -ne 0 ]; then
	
	echo "Run script with sudo command!"
	echo "Use: sudo `basename $0`"
	exit 1
  
fi

URL="https://github.com/lls-ws"

USER=`git config user.name`
USER_DIR="/home/${USER}"

REPOSITORY_NAME="$1"
REPOSITORY_DIR="${USER_DIR}/${REPOSITORY_NAME}"

REPOSITORIES=(
	"iptv"
	"cloud"
	"desktop"
	"lls-src"
	"lls-ws.github.io"
)
