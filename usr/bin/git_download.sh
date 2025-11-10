#!/bin/bash
# Script to Download GitHub Repositories
#
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. /usr/bin/git_lib.sh	|| exit 1

git_clone()
{
	
	clear
	
	echo "Downloading repository ${REPOSITORY_NAME}"
	
	(cd ${USER_DIR};git clone ${URL}/${REPOSITORY_NAME}.git; cd -)
	
	chown -R ${USER}:${USER} ${REPOSITORY_DIR}
	
	ls -al ${REPOSITORY_DIR}
	
	if [ "${REPOSITORY_NAME}" = "lls-src" ]; then
	
		(cd ${USER_DIR};
		 curl -L ${URL}/${REPOSITORY_NAME}/archive/master.zip \
			--output ${USER_DIR}/.${REPOSITORY_NAME}/${REPOSITORY_NAME}-$(date +%F).zip;
		 chown -v ${USER}:${USER} ${USER_DIR}/.${REPOSITORY_NAME}/${REPOSITORY_NAME}-$(date +%F).zip;
		 ls -al ${USER_DIR}/.${REPOSITORY_NAME}/${REPOSITORY_NAME}-$(date +%F).zip;
		 cd -)
	
	fi
	
}

git_check "clone"
