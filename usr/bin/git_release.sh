#!/bin/bash
# Script to Create Release Compress File
#
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. /usr/bin/git_lib.sh	|| exit 1

RELESEASE="$2"

git_create()
{
	
	if [ -z "${RELESEASE}" ]; then
	
		echo "Release not found!"
		echo "Type: sudo $(basename $0) ${REPOSITORY_NAME} [RELESEASE]"
		exit 1
	
	fi
	
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

git_check "create"
