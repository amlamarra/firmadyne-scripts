#!/usr/bin/env bash

# This script takes the nvram.ini file and converts it
# Firmadyne wants each key to be a separate file in libnvram.override

if [ $# -ne 2 ]; then
    echo "Provide nvram filename & Firmadyne image ID."
    echo "Usage: $0 <FILENAME> <ID>"
    echo "Example: $0 ~/nvram.ini 1"
    exit 1
fi

sudo ./scripts/mount.sh "$2"

DEST_DIR="scratch/$2/image/firmadyne/libnvram.override"
rm -f "${DEST_DIR}"/*

while read -r f; do
    if [ "${f::1}" != "#" ] && [ -n "$f" ]; then
        echo -e "$f" | cut -d= -f2 | tr -d '\n' > "${DEST_DIR}/$(echo "$f" | cut -d= -f1)"
    fi
done < "$1"

sudo ./scripts/umount.sh "$2"
