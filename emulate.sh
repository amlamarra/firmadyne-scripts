#!/usr/bin/env bash

usage() {
    echo "$0 <vendor> <path_to_firmware>"
    exit 1
}

if [ "$#" -lt 2 ] || [ ! -f "$2" ]; then
    usage
fi

exec 5>&1
iid=$(sudo ./sources/extractor/extractor.py -b "$1" \
    -sql 127.0.0.1 -np -nk "$2" \
    images | tee >(cat - >&5) | grep --color=never Database | awk '{print $NF}')
./scripts/getArch.sh "./images/$iid.tar.gz"
./scripts/tar2db.py -i "$iid" -f "./images/$iid.tar.gz"
sudo ./scripts/makeImage.sh "$iid"
./scripts/inferNetwork.sh "$iid"
