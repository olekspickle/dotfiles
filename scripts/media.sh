#!/usr/bin/env bash
# shellcheck shell=bash
# sourced utility functions

# guard against multiple sourcing
[[ -n "${__MY_FUNCS_LOADED:-}" ]] && return
__MY_FUNCS_LOADED=1

to-pdf() {
    local in
    in=$1
    libreoffice --headless --convert-to pdf $in
}

# convert all files in directory in one pdf with pwd as name
# imagemagick required
# and this should be changed in /etc/ImageMagick-*/policy.xml
# <policy domain="coder" rights="read | write" pattern="PDF" />
# there was some vulnerability bug in Ghostscript
# check the security advisory before usage
# https://www.ghostscript.com
to-pdf-all() {
    local wd ext
    wd=$(basename $(pwd))
    ext=${2:-"jpg"}
    convert -density 300 -depth 8 -quality 20 -compress jpeg *."$ext" $wd.pdf
}


# insrt/replace audio for a video with an offset
# insert audio with 500ms delay: media-merge video.mp4 audio.mp4 00:00:00.500
media-merge(){
    local video audio offset
    video=$1
    audio=$2
    offset=${3:-"00:00:00.000"}

    # set offset for any of the inputs + or - sets it ahead or behind
    # -itsoffset <+-00:00:00.000> -i <Input>
    # map first(0) stream video to first(0) out, and second(1) audio stream to first(0)
    # -map 0:v:0  -map 1:a:0
    # -c:v copy copy video stream
    ffmpeg -i "$video" -itsoffset "$offset" -i "$audio" -c:v copy -map 0:v:0 -map 1:a:0 merged.mp4
}

to-mp3(){
    local ext
    ext=${1:-"mp4"}

    case "$ext" in
        mp4)
            echo "Converting all mp4 to mp3..."
            find . -type f -name "*.$ext" -print0 -exec sh -c 'filename=${0%.*}; ffmpeg -y -i "$0" -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 "$filename.mp3";' {} \;
            ;;
        webm|wma|ogg|mkv|avi|flv|mov|m4a|wav)
            echo "Converting all $ext to mp3..."
            find . -type f -name "*.$ext" -print0 -exec sh -c 'filename=${0%.*}; ffmpeg -y -i "$0" -vn -ab 128k -ar 44100 "$filename.mp3";' {} \;
            ;;
        *)
            echo "Unsupported format: $ext"
            return 2
            ;;
    esac
}

to-ogg(){
    local ext
    ext=${1:-"wav"}

    case "$ext" in
        mp4|webm|wma|mkv|avi|flv|mov|m4a|wav|mp3)
            echo "Converting all $ext to ogg..."
            # ffmpeg -i "$input" -vn -acodec libvorbis -ac 2 -ab 192k -ar 44100 "$output"
            find . -type f -name "*.$ext" -print0 -exec sh -c 'filename=${0%.*}; ffmpeg -y -i "$0" -vn -ac 2 -c:a libvorbis -q:a 10 -ar 44100 "$filename.ogg"' {} \;
            ;;
        *)
            echo "Unsupported format: $ext"
            return 2
            ;;
    esac
}

# to-slack-gif input.mp4 <output.gif>
to-slack-gif() {
    local in out base scale fps
    in=${1:-"input.mp4"}

    if [ ! -f "$in" ]; then
        echo "No such file: $in"
        return 1
    fi

    base="${in%.*}"
    out=${2:-"$base.gif"}
    scale=${3:-"128:-1"}
    fps=${4:-"10"}

    # for gif it's mostly fps
    ffmpeg -i "$in" \
        -vf "fps=${fps},scale=${scale}:flags=lanczos" \
        -c:v gif -b:v 64k \
        "$out"
}

to-slack-img() {
    local in out base
    in=${1:-"input.mp4"}

    if [ ! -f "$in" ]; then
        echo "No such file: $in"
        return 1
    fi

    base="${in%.*}"
    out="$base.gif"

    # -c:v libx264: This option sets the efficient video codec to H.264
    # -crf 28: The Constant Rate Factor (CRF) determines the video quality
    # A lower value results in higher quality but larger file size. moderate - 28
    # -preset slow: This preset option controls the encoding speed and quality trade-off.
    # The "slow" preset provides better compression efficiency, but it's slower.
    # If you want faster encoding, you can choose a different preset like "medium" or "fast".
    # -c:a aac -b:a 128k: These options specify the audio codec as AAC and set the audio bitrate to 128kbps.
    ffmpeg -i "$in" -vf "scale=128:128" -c:v libx264 -crf 28 -preset slow -c:a aac -b:a 128k "$out"
}

# usage
# gifify -i <video> [-o OUTPUT] [-c CROP] [-f FPS] [-s SCALE] [-l LOOP]
gifify() {
    # Reset variables so that sequential runs with positional arg do not crash
    local input output crop scale dither fps loop base filters palette_file

    # unpack arguments
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
            --crop | -c)
                crop="$2"
                shift # past argument
                shift # past value
                ;;
            --scale | -s)
                scale="$2"
                shift # past argument
                shift # past value
                ;;
            --dither | -d)
                dither="$2"
                shift # past argument
                shift # past value
                ;;
            --fps | -f)
                fps="$2"
                shift # past argument
                shift # past value
                ;;
            --loop | -l)
                loop="$2"
                shift # past argument
                shift # past value
                ;;
            --help | -h)
                echo "gifify <video> [-o OUTPUT] [-c CROP] [-f FPS] [-s SCALE] [-l LOOP] [-d DITHER]\n"
                echo "-i,--input    input path"
                echo "-o,--output   output path"
                echo "-d,--dither   dither palette use, default - bayer.[bayer, none]"
                echo "-f,--fps      filter sets the frame rate"
                echo "-s,--scale    scale filter will resize the output to 320 pixels wide and automatically determine the height while preserving the aspect ratio. The lanczos scaling algorithm is used in this example. example: 640:-1"
                echo "-c,--crop     example: 'iw-100:ih' to crop 100px horizontally(50 from each side)"
                echo "-l,--loop     Control looping with -loop output option but the values are confusing. A value of 0 is infinite looping, -1 is no looping, and 1 will loop once meaning it will play twice. So a value of 10 will cause the GIF to play 11 times"
                echo "\nA few ffmpeg related docs:\npalettegen    https://ffmpeg.org/ffmpeg-filters.html#palettegen\npaletteuse    https://ffmpeg.org/ffmpeg-filters.html#paletteuse\nsplit         https://ffmpeg.org/ffmpeg-filters.html#split_002c-asplit"
                return 0
                ;;
            -*) # unknown option
                echo "Unknown option: $1" >&2
                return 0
                ;;
            *)  # positional input
                if [ -z "$input" ]; then
                    input="$1"
                else
                    echo "Unexpected positional argument: $1" >&2
                    return 1
                fi
                shift
                ;;
        esac
    done

    if [ -z "$input" ]; then
        input="input.mp4"
    fi

    # save basename
    base="${input%.*}"
    if [ -z "$output" ]; then
        output="$base.gif"
    fi

    if [ ! -z "$crop" ]; then
        crop=",crop=$crop"
    fi

    if [ -z "$scale" ]; then
        scale="iw:ih"
    fi

    if [ -z "$dither" ]; then
        dither="bayer:bayer_scale=3"
    fi

    if [ -z "$fps" ]; then
        fps="24"
    fi

    if [ -z "$loop" ]; then
        loop="0"
    fi


    # generate palette from video
    palette_file="/tmp/palette.png"
    filters="fps=$fps$crop,scale=$scale\:flags=lanczos"
    ffmpeg -y -i "${input}" -vf "$filters,palettegen" -update 1 "${palette_file}"
    ffmpeg -y -i "${input}" -i "${palette_file}" \
        -filter_complex "[0:v]${filters}[p];[p][1:v]paletteuse=dither=$dither" \
        -loop "$loop" "${output}"
}

# format-track -i in.wav -c my-cover.jpg
format-track() {
    local input output title artist album ext cover genre style video key cmd default

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
                shift
                shift
                ;;
            --title | -t)
                title="$2"
                shift
                shift
                ;;
            --artist)
                artist="$2"
                shift
                shift
                ;;
            --album | -a)
                album="$2"
                shift
                shift
                ;;
            --ext | -e)
                ext="$2"
                shift
                shift
                ;;
            --cover | -c)
                cover="$2"
                shift
                shift
                ;;
            --genre | -g)
                genre="$2"
                shift
                shift
                ;;
            --style | -s)
                style="$2"
                shift
                shift
                ;;
            --video | -v)
                video=true
                shift
                shift
                ;;
            --help | -h)
                echo "File IO:"
                echo "-i,--input    input file"
                echo "-o,--output   output file"
                echo "-e,--ext      extension of the output file"
                echo "\nMeta information:"
                echo "-s,--style    music styles: 'synth rhytmic,slow beat'"
                echo "-t,--title    composition title for meta"
                echo "-g,--genre    music genre: 'synthwave'"
                echo "-c,--cover    composition cover: 'cover.jpg'"
                echo "-a,--album    album name"
                echo "-v,--video    bool,format output as video"
                echo "--artist      artist name"
                return 0
                ;;
            *) # unknown option
                echo "Unknown option: $key"
                return 0
                ;;
        esac
    done

    # Default if not present
    if [ -z "$input" ]; then
        echo "specify input file"
        return 0
    fi

    cmd=(ffmpeg -y -loglevel warning -i "$input")

    if [ -z "$title" ]; then
        title="${input%.*}"
    fi

    if [ -z "$ext" ]; then
        ext="mp3"
    fi

    if [ -z "$output" ]; then
        output="${title}.${ext}"
        echo "No output file name, using input title ${output}"
    fi

    if [ -z "$artist" ]; then
        artist="smnbl"
    fi

    if [ -z "$album" ]; then
        album="starter"
    fi

    if [[ ! -f "$cover" ]]; then
        default="cover.jpg"
        if [[ -f "$default" ]]; then
            cover="$default"
        fi
    fi
    if [[ -n "$cover" && "$cover" != "0" ]]; then
        echo "cover image: $cover"
        cmd+=(-i "$cover" -map 1:v:0)
    else
        echo "no cover image"
    fi


    if [ -z "$genre" ]; then
        genre="electronic"
    fi

    if [ -z "$style" ]; then
        style="synth,rhytmic"
    fi

    echo "Convert $input > $output"
    echo "Title: $title"
    echo "Artist: $artist"
    echo "Album: $album, Genre: $genre, Style: $style"

    cmd+=(
        -map 0:a:0 -id3v2_version 3 \
            -disposition:v:1 attached_pic \
            -c:a libmp3lame -qscale:a 2 \
            -metadata:s:v title="${album} album cover" \
            -metadata:s:v comment="${album} cover (front)" \
            -metadata artist="${artist}" \
            -metadata title="${title}" \
            -metadata album="${album}" \
            -metadata genre="${genre}" \
            -metadata style="${style}" \
            "$artist-${output}"
        )

        echo "FFMPEG command: $cmd"

        "${cmd[@]}"
        # ffmpeg -y -loglevel warning \
        #     -i "$input" -i "$cover" \
        #     -map 0:a:0 -map 1:v:0 -id3v2_version 3 \
        #     -disposition:v:1 attached_pic \
        #     -codec:a libmp3lame -b:a 128k -vn -qscale:a 2  \
        #     -metadata:s:v title="${album} album cover" \
        #     -metadata:s:v comment="${album} cover (front)" \
        #     -metadata artist="${artist}" \
        #     -metadata title="${title}" \
        #     -metadata album="${album}" \
        #     -metadata genre="${genre}" \
        #     -metadata style="${style}" \
        #     "${output}"
    }

# to-yt track.mp3 cover.jpg
to-yt() {
    local out in
    in=${1:-"input.mp3"}
    out="${1%.*}"

    ffmpeg -y -i "$in" \
        -map 0:a -map 0:v \
        -c:a aac -b:a 192k \
        -c:v libx264 -tune stillimage \
        -vf "fps=2,scale=1280:-1:force_original_aspect_ratio=decrease" \
        -shortest "$out.mp4"
    # ffmpeg -y -i $1 -c:a copy -shortest -c:v libx264 "$out.mp4"
}

return 0 2>/dev/null || true
