#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Function to display usage information
usage() {
    echo "Usage: $0 [OPTION]"
    echo "Manage custom icons for macOS applications"
    echo ""
    echo "Options:"
    echo "  set       Set custom icons for all applications (default)"
    echo "  reset     Reset all applications to their original icons"
    echo "  -h, --help    Display this help message"
    echo ""
    echo "Examples:"
    echo "  $0 set      # Set all custom icons"
    echo "  $0 reset    # Reset all icons to original"
    echo "  $0          # Same as 'set' (default behavior)"
    exit 0
}

# Function to check if fileicon is installed
check_fileicon() {
    if ! command -v fileicon &> /dev/null
    then
        echo "Error: fileicon could not be found"
        echo "Install with: brew install fileicon"
        exit 1
    fi
}

# Function to set custom icons
set_icons() {
    echo "Setting custom icons..."
    echo "Script directory: $SCRIPT_DIR"

    local count=0
    for file in "$SCRIPT_DIR"/icons/*.icns; do
        if [ ! -f "$file" ]; then
            echo "No icon files found in $SCRIPT_DIR/icons/"
            exit 1
        fi

        filename=$(basename "$file")
        filename="${filename%.*}"

        if [ -d "/Applications/$filename.app" ]; then
            echo "  Setting icon for $filename"
            fileicon set "/Applications/$filename.app" "$file" > /dev/null 2>&1 &
            ((count++))
        else
            echo "  Skipping $filename (application not found)"
        fi
    done

    wait
    echo "Done! Set $count custom icon(s)"
}

# Function to reset icons to original
reset_icons() {
    echo "Resetting icons to original..."
    echo "Script directory: $SCRIPT_DIR"

    local count=0
    for file in "$SCRIPT_DIR"/icons/*.icns; do
        if [ ! -f "$file" ]; then
            echo "No icon files found in $SCRIPT_DIR/icons/"
            exit 1
        fi

        filename=$(basename "$file")
        filename="${filename%.*}"

        if [ -d "/Applications/$filename.app" ]; then
            echo "  Resetting icon for $filename"
            fileicon rm "/Applications/$filename.app" > /dev/null 2>&1 &
            ((count++))
        else
            echo "  Skipping $filename (application not found)"
        fi
    done

    wait
    echo "Done! Reset $count icon(s) to original"
}

# Main script logic
check_fileicon

# Parse command line arguments
case "${1:-set}" in
    set)
        set_icons
        ;;
    reset)
        reset_icons
        ;;
    -h|--help)
        usage
        ;;
    *)
        echo "Error: Unknown option '$1'"
        echo ""
        usage
        ;;
esac
