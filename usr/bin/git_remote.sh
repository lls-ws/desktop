#!/bin/bash
# Script to Upload GitHub Repositories
#
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. /usr/bin/git_lib.sh	|| exit 1

git_upload()
{
	
	TOKEN=`git config user.token`
	
	if [ -z "${TOKEN}" ]; then
		
		echo "Use: cloud/bin/git_conf.sh token {TOKEN}"
		exit 1
		
	fi
	
	echo "Updating repository ${REPOSITORY_NAME}"
	
	(cd ${REPOSITORY_DIR};
	 git add .;
	 git commit -m "Add files remotely";
	 git remote set-url origin ${URL:0:6}//${TOKEN}@${URL:8:17}/${REPOSITORY_NAME}.git;
	 git push -u origin main;
	 cd -)
	
}

git_check "upload"
