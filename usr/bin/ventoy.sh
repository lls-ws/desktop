#!/bin/sh

FILE="$1"

if [ -z "${FILE}" ]; then

	echo "File not found!"
	echo "Run: $(basename $0) [ISO]"
	exit 1;

fi

FILE_NAME="${FILE%.*}"

ISO_DIR="/home/shared/iso"

if [ ! -f "${ISO_DIR}/${FILE_NAME}.iso" ]; then

	echo "${FILE_NAME} not found!"
	echo "Run: $(basename $0) ${FILE_NAME}.iso"
	exit 1;

fi

VENTOY_DIR="/run/media/lls/Ventoy"

if [ ! -d "${VENTOY_DIR}" ]; then

	echo "Ventoy not found!"
	echo "Run: sudo mount /dev/sdb1 /run/media/lls/Ventoy"
	exit 1;

fi

sudo cp -fv ${ISO_DIR}/${FILE_NAME}.iso ${VENTOY_DIR}
bash sha256sum.sh "${FILE_NAME}.iso"
sudo umount ${VENTOY_DIR}/
