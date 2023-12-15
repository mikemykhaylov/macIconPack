#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "Script directory: $SCRIPT_DIR"

# Check that fileicon is installed
if ! command -v fileicon &> /dev/null
then
    echo "fileicon could not be found"
    echo "Install with: brew install fileicon"
    exit
fi

for file in "$SCRIPT_DIR"/icons/*.icns; do
    filename=$(basename "$file")
    filename="${filename%.*}"
    echo "Loading icon $filename"
    fileicon set "/Applications/$filename.app" "$file" > /dev/null &
done
