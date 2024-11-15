#!/bin/bash

# convert all m4a files in the folder to ogg

for f in *.m4a; do
    ffmpeg -i "$f" -c:a libvorbis "${f%.m4a}.ogg"
done
