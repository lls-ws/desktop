#!/bin/bash
# Script to Update Github Repositories
#
# email: lls.homeoffice@gmail.com

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
)
