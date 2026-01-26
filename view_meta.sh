#!/bin/bash
# View image metadata

command -v exiftool >/dev/null 2>&1 || {
    echo "Error: exiftool not installed"
    exit 1
}

[ $# -eq 0 ] && {
    echo "Usage: $0 <image_file>"
    exit 1
}

[ ! -f "$1" ] && {
    echo "Error: File '$1' not found"
    exit 1
}

echo "Metadata for: $1"
echo "================================"
exiftool "$1"
