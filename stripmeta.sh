#!/bin/bash

# Strip metadata from images

command -v exiftool >/dev/null 2>&1 || {
    echo "Error: exiftool not installed"
    echo "Install: sudo apt install libimage-exiftool-perl"
    exit 1
}

DIR="${1:-.}"

[ ! -d "$DIR" ] && {
    echo "Error: Directory '$DIR' not found"
    exit 1
}

# Find images
FILES=$(find "$DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.tiff" -o -iname "*.bmp" \) 2>/dev/null)

COUNT=$(echo "$FILES" | grep -c .)

[ $COUNT -eq 0 ] && {
    echo "No images found in $DIR"
    exit 0
}

echo "Found $COUNT images in $DIR"
printf "Continue? (y/n): "
read -r reply

case "$reply" in
    y|Y) ;;
    *) echo "Aborted"; exit 0 ;;
esac

echo ""
echo "Processing..."
echo ""

SUCCESS=0
FAILED=0

# Process each file individually
while IFS= read -r file; do
    [ -z "$file" ] && continue

    printf "Processing: $(basename "$file") ... "

    if exiftool -all= -overwrite_original "$file" >/dev/null 2>&1; then
        echo "OK"
        SUCCESS=$((SUCCESS + 1))
    else
        echo "FAILED"
        FAILED=$((FAILED + 1))
    fi
done <<< "$FILES"

echo ""
echo "================================"
echo "Success: $SUCCESS"
echo "Failed:  $FAILED"
echo "================================"
