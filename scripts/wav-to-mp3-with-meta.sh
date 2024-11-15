#!/bin/bash

set -x

# Convert exported wav files to an mp3 with metadata
artist="oleks pickle"
input=$1
output=${2:-$(date "+%d-%m-%Y-%H-%M.mp3")}
name=${3-"${output%.*}"}
ext=${4:-"${output##*.}"}
album=${5:-"game-ost"}

if [ ! -f ${name}.${ext} ]; then
    new_name=${name}.${ext}
else
    new_name=${name}$((1 + RANDOM % 10)).${ext}
fi

ffmpeg -i ${input} -c copy \
    -codec:a libmp3lame -qscale:a 2 \
    -metadata artist="${artist}" \
    -metadata title="${name}" \
    -metadata album="${album}" \
    $new_name
