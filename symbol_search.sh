#!/usr/bin/env bash
# Search a binary's imported libraries for a specific symbol to see which library has it.
# Dependencies: readelf

#set -x

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 BINARY SYMBOL"
    exit 1
fi

search_dir=./root

for file in $(readelf -d "$1" | grep Shared | cut -d\[ -f2 | cut -d\] -f1); do
    if find "$search_dir" -name "$file" -type f -exec readelf -s {} 2>/dev/null + | grep "$2" >/dev/null; then
        find "$search_dir" -name "$file" -type f
    fi
done
