#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "Script directory: $SCRIPT_DIR"

for file in "$SCRIPT_DIR"/icons/*.icns; do
    filename=$(basename "$file")
    filename="${filename%.*}"
    echo "Loading icon $filename"
    fileicon set "/Applications/$filename.app" "$file" > /dev/null &
done
