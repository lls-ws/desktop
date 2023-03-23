#!/bin/sh
# Script to get a screenshot
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

USER=$(whoami)

if [ "${USER}" = "root" ]; then
    
    echo "Usuario root não permitido!"
    
    exit 1;
    
fi

ARQ_IMG="screenshot"
EXT_IMG="jpg"
CONT_IMG=$(( 1 ))
ARQ_TMP=$(echo "${ARQ_IMG}_0${CONT_IMG}")

DIR_IMG="/home/${USER}/Imagens"

while true
do    
    
    if [ -e ${DIR_IMG}/${ARQ_TMP}.${EXT_IMG} ]; then
	
		CONT_IMG=$(expr ${CONT_IMG} + 1 )
		
		NUM_IMG=""
	
		if [ ${CONT_IMG} -lt 10 ]; then
			
			NUM_IMG=$(echo "0${CONT_IMG}")
			
		else
			
			NUM_IMG=${CONT_IMG}
			
		fi
	
		ARQ_TMP=$(echo "${ARQ_IMG}_${NUM_IMG}")
	
    else
		break;
    fi
    
done

ARQ_IMG=$(echo ${DIR_IMG}/${ARQ_TMP}.${EXT_IMG})

import -window root ${ARQ_IMG}

if [ -e ${ARQ_IMG} ]; then

    ristretto ${ARQ_IMG}

fi
