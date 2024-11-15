#!/bin/bash

# for some reason it processes some files but misses some of them

# Find all MP3/MP4/M4A files in the current directory and its subdirectories
find . -type f \( -name "*.mp3" -o -name "*.mp4" -o -name "*.m4a" \) -print0 | while IFS= read -r -d '' file; do

    # Get the filename without extension
    filename="${file%.*}"

    # Convert filename to lowercase and replace spaces with hyphens
    new_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

    # Construct the output filename with .ogg extension
    output_file="${new_filename}.ogg"
    # Convert the file to OGG format using ffmpeg
    echo "${file}" "${output_file}"
    ffmpeg -y -i "${file}" -c:a libvorbis "${output_file}"
done
