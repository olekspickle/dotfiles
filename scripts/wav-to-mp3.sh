#!/bin/bash

set -e

# Convert exported wav files to an mp3 with metadata

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "
        Usage: ./wav-to-mp3.sh -i input.wav -o out.mp3
        Flags:
        --input,-i  -   Input file
        --output,-o -   Output file
        --title,-t  -   Track title
        --artist,-a -   Artists name
        --album     -   Album name
        --genre     -   Track genre (electro,rock)
        --style     -   Track style (ambient,synth,rhytmic,dnb)
        --cover     -   Track cover photo path
        --ext       -   Extension of an output
    "
    exit 0
fi
# Parse named arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --input | -i)
            input="$2"
            shift # past argument
            shift # past value
            ;;
        --output | -o)
            output="$2"
            shift # past argument
            shift # past value
            ;;
        --title | -t)
            title="$2"
            shift # past argument
            shift # past value
            ;;
        --artist | -a)
            artist="$2"
            shift # past argument
            shift # past value
            ;;
        --album)
            album="$2"
            shift # past argument
            shift # past value
            ;;
        --cover | -c)
            cover="$2"
            shift # past argument
            shift # past value
            ;;
        --genre | -g)
            genre="$2"
            shift # past argument
            shift # past value
            ;;
        --style | -s)
            style="$2"
            shift # past argument
            shift # past value
            ;;
        --ext)
            ext="$2"
            shift # past argument
            shift # past value
            ;;
        *) # unknown option
            echo "Unknown option: $key"
            exit 1
            ;;
    esac
done

# Default if not present
if [ -z "$input" ]; then
    echo "No input file"
    exit 1
fi

if [ -z "$ext" ]; then
    ext="${output##*.}"
fi

if [ -z "$title" ]; then
    title="${output%.*}"
fi

if [ -z "$output" ]; then
    output="${title}.${ext}"
    echo "No output file name, using input title ${output}"
fi

if [ -z "$artist" ]; then
    artist="somnamboola"
fi

if [ -z "$album" ]; then
    album="starter"
fi

if [ -z "$cover" ]; then
    cover="cover.jpg"
fi

if [ -z "$genre" ]; then
    genre="electro"
fi

if [ -z "$style" ]; then
    style="synth rhytmic"
fi

echo "Convert $input > $output"
echo "Artist: $artist"
echo "Title: $title"
echo "Album: $album, Genre: $genre, Style: $style"

ffmpeg -hide_banner -loglevel warning \
    -i ${input} -i $cover \
    -map 0 -map 1 -c copy -id3v2_version 3 \
    -codec:a libmp3lame -b:a 128k -vn -qscale:a 2  \
    -metadata:s:v title="${album} album cover" \
    -metadata:s:v comment="${album} cover (front)" \
    -metadata artist="${artist}" \
    -metadata title="${title}" \
    -metadata album="${album}" \
    -metadata genre="${genre}" \
    -metadata style="${style}" \
    "${output}"
