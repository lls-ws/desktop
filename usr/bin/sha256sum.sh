#!/bin/sh

FILE="$1"

if [ -z "${FILE}" ]; then

	echo "File not found!"
	echo "Run: $(basename $0) [ISO]"
	exit 1;

fi

DIST_NAME=$(echo "${FILE}" | cut -d '-' -f1)

echo "${DIST_NAME}"

RELEASE=$(. /etc/os-release; echo ${VERSION_CODENAME})
VERSION=$(. /etc/os-release; echo ${VERSION_ID})

if [ "${DIST_NAME}" = "ubuntu" ]; then

	wget https://releases.ubuntu.com/${RELEASE}/SHA256SUMS

else

	wget https://cdimage.ubuntu.com/lubuntu/releases/${VERSION}/release/SHA256SUMS

fi

echo "Checking sha256sum..."

sha256sum ${FILE}

cat SHA256SUMS | grep "${FILE}" | awk '{print $1}'

rm -fv SHA256SUMS
