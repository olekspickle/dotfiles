#!/usr/bin/env bash
# shellcheck shell=bash
# sourced utility functions

# insrt/replace audio for a video with an offset
# insert audio with 500ms delay: media-merge video.mp4 audio.mp4 00:00:00.500
media-merge(){
    local video audio offset out
    video=${1:?"usage: media-merge <video> <audio> [offset] [out]"}
    audio=${2:?"usage: media-merge <video> <audio> [offset] [out]"}
    offset=${3:-"00:00:00.000"}
    out=${4:-"merged.mp4"}

    # set offset for any of the inputs + or - sets it ahead or behind
    # -itsoffset <+-00:00:00.000> -i <Input>
    # map first(0) stream video to first(0) out, and second(1) audio stream to first(0)
    # -map 0:v:0  -map 1:a:0
    # -c:v copy copy video stream
    ffmpeg -i "$video" -itsoffset "$offset" -i "$audio" -c:v copy -map 0:v:0 -map 1:a:0 "$out"
}

respeed() {
    # Respeed video+audio: mul>1 slower, mul<1 faster
    # respeed output.mkv output_slow.mkv 3

    local in="$1" out="$2" mul="$3"
    [[ -z "$mul" ]] && { echo "Usage: respeed <input> <output> <multiplier>"; return 1; }
    local rate=$(bc -l <<< "1/$mul")

    # Chain atempo for values outside [0.5, 2.0]
    local af=""; local r=$rate
    while (( $(bc -l <<< "$r < 0.5") )); do af+="atempo=0.5,"; r=$(bc -l <<< "$r / 0.5"); done
    while (( $(bc -l <<< "$r > 2.0") )); do af+="atempo=2.0,"; r=$(bc -l <<< "$r / 2.0"); done
    af+="atempo=$r"

    ffmpeg -i "$in" -filter:v "setpts=${mul}*PTS" -af "$af" "$out"
}



# _vid-stack <v|h> in1 in2 ... [out]
# last arg is the output unless it's an existing file; default output.mp4
_vid-stack(){
    local dir=$1; shift
    local out="output.mp4" dim scale f i=0 n filter="" labels=""
    local inputs=()

    if (( $# > 2 )) && [[ ! -e "${@: -1}" ]]; then
        out="${@: -1}"
        set -- "${@:1:$(($# - 1))}"
    fi
    n=$#
    if (( n < 2 )); then
        echo "usage: vid-${dir}stack in1 in2 [in3 ...] [out]" >&2
        return 1
    fi

    # stack axis needs a shared dimension: width for vstack, height for hstack
    if [[ $dir == v ]]; then
        dim=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$1")
        scale="$dim:-2"
    else
        dim=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$1")
        scale="-2:$dim"
    fi

    for f in "$@"; do
        inputs+=(-i "$f")
        filter+="[$i:v]scale=$scale,setsar=1[s$i];"
        labels+="[s$i]"
        i=$((i + 1))
    done
    filter+="${labels}${dir}stack=inputs=${n}[v]"

    ffmpeg "${inputs[@]}" -filter_complex "$filter" -map "[v]" -map "0:a?" -c:a copy "$out"
}

vid-vstack(){ _vid-stack v "$@"; }
vid-hstack(){ _vid-stack h "$@"; }

# vid-scale <in> <size> [out]   works for images and videos, keeps aspect unless WxH
#   size: 50% | 0.5 | 1280 (width) | x720 (height) | 1280x720 (exact) | W:H (raw ffmpeg)
vid-scale(){
    local in=$1 size=$2 out f vf
    if [[ -z $in || -z $size ]]; then
        echo "usage: vid-scale <in> <50%|0.5|1280|x720|1280x720|W:H> [out]" >&2
        return 1
    fi
    out=${3:-"${in%.*}_scaled.${in##*.}"}

    # trunc(../2)*2 keeps dims even, which h264/h265 require
    case $size in
        *%)        f=$(bc -l <<< "${size%\%} / 100")
                   vf="scale=trunc(iw*$f/2)*2:trunc(ih*$f/2)*2" ;;
        0.*|*.*)   vf="scale=trunc(iw*$size/2)*2:trunc(ih*$size/2)*2" ;;
        *:*)       vf="scale=$size" ;;
        x*)        vf="scale=-2:${size#x}" ;;
        *x*)       vf="scale=${size%x*}:${size#*x}" ;;
        *)         vf="scale=${size}:-2" ;;
    esac

    ffmpeg -i "$in" -vf "$vf" -c:a copy "$out"
}



# vid-merge '*.mp4' [output]  — glob pattern (quote it!)
# vid-merge file1 file2 ... output  — explicit file list
vid-merge(){
    local pattern out
    local files=()

    if [[ $1 == *[*?[]* ]]; then
        pattern=$1
        out=${2:-"concat.mp4"}
        while IFS= read -r f; do
            files+=("$f")
        done < <(find . -maxdepth 1 -type f -name "$pattern" 2>/dev/null | sed 's|^\./||' | sort)
    else
        out="${@: -1}"
        local rest=("${@:1:$#-1}")
        for f in "${rest[@]}"; do
            [ -f "$f" ] && files+=("$f")
        done
    fi

    if [ ${#files[@]} -eq 0 ]; then
        echo "no files to merge"
        return 1
    fi
    printf '%s\n' "${files[@]}" | while IFS= read -r f; do
        printf "file '%s'\n" "$f"
    done > list.txt
    ffmpeg -f concat -safe 0 -i list.txt -c:v libx264 -c:a aac "$out"
    echo "$out"
}



# download from google drive in scripts
# when setting up the access to anyone with  the link, extract
# the file id from the link: drive.google.com/file/d/<file_id>/...
download-from-google(){
    local FILE_ID out
    FILE_ID=${1:?"usage: download-from-google <file-id> [out]"}
    out=${2:-"google-download-output"}

    # Step 1: get confirmation token
    curl -c cookies.txt -s "https://drive.google.com/uc?export=download&id=$FILE_ID" \
    | grep -o 'confirm=[^&]*' | sed 's/confirm=//' > token.txt
    TOKEN=$(cat token.txt)

    # Step 2: download with token
    curl -Lb cookies.txt "https://drive.google.com/uc?export=download&confirm=$TOKEN&id=$FILE_ID" -o "$out"
    rm cookies.txt token.txt
}

to-pdf(){
    local in
    in=${1:?"usage: to-pdf <file>"}
    libreoffice --headless --convert-to pdf "$in"
}

# convert all files in directory in one pdf with pwd as name
# imagemagick required
# and this should be changed in /etc/ImageMagick-*/policy.xml
# <policy domain="coder" rights="read | write" pattern="PDF" />
# there was some vulnerability bug in Ghostscript
# check the security advisory before usage
# https://www.ghostscript.com
to-pdf-all(){
    local wd ext
    wd=$(basename $(pwd))
    ext=${2:-"jpg"}
    convert -density 300 -depth 8 -quality 20 -compress jpeg *."$ext" $wd.pdf
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
    local input output crop scale dither fps loop base filters palette_file palette max_colors

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
            --palette | -p)
                max_colors="$2"
                shift # past argument
                shift # past value
                ;;
            --help | -h)
                echo "gifify <video> [-o OUTPUT] [-c CROP] [-f FPS] [-s SCALE] [-l LOOP] [-d DITHER]\n"
                echo "Example:  gifify -i input.mp4 -f 12 -s '300:-1' -d bayer -p 256"
                echo "-i,--input    input path"
                echo "-o,--output   output path"
                echo "-d,--dither   dither palette use, default: bayer.\n[bayer, none]"
                echo "-f,--fps      filter sets the frame rate"
                echo "-p,--palette  max_colors for palette, default: 128\n[32,64,128,256]"
                echo "-s,--scale    scale filter will resize the output to 320 pixels wide and automatically determine the height while preserving the aspect ratio. The lanczos scaling algorithm is used in this example. example: 640:-1"
                echo "-c,--crop     example: 'iw-100:ih' to crop 100px horizontally(50 from each side)"
                echo "-l,--loop     Control looping with -loop output option but the values are confusing. A value of 0 is infinite looping, -1 is no looping, and 1 will loop once meaning it will play twice. So a value of 10 will cause the GIF to play 11 times"
                echo "\nA few ffmpeg related docs:\npalettegen    https://ffmpeg.org/ffmpeg-filters.html#palettegen\npaletteuse    https://ffmpeg.org/ffmpeg-filters.html#paletteuse\nsplit         https://ffmpeg.org/ffmpeg-filters.html#split_002c-asplit"
                return 0
                ;;
            -*) # unknown option
                echo "Unknown option: $1" >&2
                return 1
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

    if [ -z "$max_colors" ]; then
        max_colors="128"
    fi


    # generate palette from video
    palette_file="/tmp/palette.png"
    filters="fps=$fps$crop,scale=$scale\:flags=lanczos"
    palette="$filters,palettegen=max_colors=$max_colors"
    ffmpeg -y -i "${input}" -vf "$palette" -update 1 "${palette_file}"
    ffmpeg -y -i "${input}" -i "${palette_file}" \
        -filter_complex "[0:v]${filters}[p];[p][1:v]paletteuse=dither=$dither:diff_mode=rectangle" \
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
        return 1
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

# frames-to-vid 'frame-*.png' [output.mp4] -r 30
frames-to-vid() {
    local pattern output framerate
    pattern=${1:?"usage: frames-to-vid <glob-pattern> [output] [-r fps]"}
    output="${2:-output.mp4}"
    framerate=30
    shift
    [[ $# -gt 0 && "${1:0:1}" != "-" ]] && shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -r) framerate="$2"; shift 2 ;;
            *)  echo "Unknown: $1"; return 1 ;;
        esac
    done
    ffmpeg -y -framerate "$framerate" -f image2 -pattern_type glob -i "$pattern" -c:v libx264 -pix_fmt yuv420p "$output"
}

# to-yt track.mp3 cover.jpg
to-yt() {
    local audio cover out
    audio=${1:?"usage: to-yt <audio> <cover-image>"}
    cover=${2:?"usage: to-yt <audio> <cover-image>"}
    out="${audio%.*}.mp4"

    ffmpeg -y -loop 1 -i "$cover" -i "$audio" \
        -map 0:v -map 1:a \
        -c:v libx264 -tune stillimage -vf "scale=1280:-1:force_original_aspect_ratio=decrease" \
        -c:a aac -b:a 192k \
        -shortest "$out"
}

# to-mp4 input.mkv
to-mp4() {
    local input out
    input=${1:?"usage: to-mp4 <video>"}
    out="${input%.*}.mp4"

    ffmpeg -y -i "$input" \
        -c:v libx264 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$out"
}

# to-webp input.png
to-webp() {
    local in out
    in=${1:?"usage: to-webp <image>"}
    out="${in%.*}.webp"

    ffmpeg -y -i "$in" "$out"
}

