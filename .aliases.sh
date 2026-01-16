#!/bin/bash

# global stuff
alias fix-amd-gpu="sudo cat /sys/kernel/debug/dri/1/amdgpu_gpu_recover"
alias firefox="flatpak run --branch=stable --arch=x86_64 --command=firefox --file-forwarding org.mozilla.firefox"
alias restart-pipewire='systemctl --user restart pipewire.socket pipewire-pulse.socket wireplumber.service'
alias update-all='sh ~/Documents/dotfiles/update.sh'
alias dx-serve='BEVY_ASSET_ROOT=. dx serve --hot-patch'
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'
# Clean log from colors
alias clean-logs="sed 's/\x1b\[[0-9;]*m//g'"
# sudo not knowing aliases workaround
alias sudo='sudo '
# oxidize
alias fd='fdfind'

alias virtualenv="uv venv"
alias adbsync='~/.venv/bin/adbsync'
alias yt='yt-dlp -x --audio-format mp3'
alias rabbit-inspect='rabbitmqctl list_queues | grep -v -e "0"'
alias docker-container-rm-all-force='docker ps -q | xargs -I {} docker rm -f {}'
alias co-main='git checkout $(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name)'
alias speedtest='cat -p ~/Documents/py/speedtest.py | python -'
alias carla='flatpak run studio.kx.carla'

# zellij hotkeys
alias zj="zellij"
alias zjm="zj -s main -n main || zj attach main"
alias zjs="zj -s simple -n simple || zj attach simple"
alias zjp="zj -s ollama -l pi || zj attach ollama"

alias vim="nvim"
alias vi="nvim"
alias python='python3'

alias gbb="git bb"
alias gb="git branch"
alias gc="git checkout"
alias ga="git add"
alias gd="git diff"
alias gs="git status"
alias tf="terraform"

alias bored="nmap -Pn -sS -p 80 -iR 0 --open"
alias battery="upower -i $(upower -e | grep 'BAT')"
alias bombard="docker run -ti --rm alpine/bombardier -c 1000 -d 3600s -l $1"

alias myip="curl http://ipecho.net/plain; echo"
#musl
alias rust-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# pretty xev
alias xev-pretty="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"

# AWS
# command that connects to localstack instead of real AWS server
alias aws-local="aws --endpoint-url http://127.0.0.1:4566"

# show logs without weird sequences
# sudo apt install colorized-logs
function logless(){
    ansi2txt < $1 | less
}

function strip-logs() {
    local in out
    in=${1:-"input.log"}
    out=${2:-"output.log"}

    # Strips all escape sequences and control codes from stdin.
    cat -p "$in" | sed -e 's,[\x00-\x08\x0E-\x1F]\|\x1B\(\[[0-?]*[ -/]*[@-~]\),,g' > "$out"
}


function rot13() {
    cat -p | tr "$(echo -n {A..Z} {a..z} | tr -d ' ')" "$(echo -n {N..Z} {A..M} {n..z} {a..m} | tr -d ' ')"
}

function sup() {
    if [ -z "$1" ]; then
        echo "Check the memory and CPU the process currently holds.\nUsage: sup <process_name>"
        return 1
    fi

    pids=$(pgrep -f "$1" | paste -sd, -)

    if [ -z "$pids" ]; then
        echo "No matching processes found for '$1'"
        return 1
    fi

    ps -p "$pids" -o pid=,rss=,pcpu= | awk '
    {mem+=$2; cpu+=$3}
END {
    printf "Memory: %.2f MB\n", mem/1024
    printf "CPU: %.2f%%\n", cpu
}'
}

# wargames <user>
function wargames() {
    ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password  -p 2220 "$1"@bandit.labs.overthewire.org
}

function git-sign-all-commits() {
    # to make it better - add key to an ssh-agent
    git rebase --exec 'git commit --amend --no-edit -S' -i --root
}
function git-sign-n() {
    local n

    n=${1:-1}
    git rebase --exec 'git commit --amend --no-edit -S' HEAD~"$n"
}
function git-reset-author() {
    git rebase -r --root --exec 'git commit --amend --no-edit --reset-author'
}
function git-rename() {
    OLD=${1:- };
    NEW=${2:- };
    echo old: $OLD new: $NEW;

    git ls-files -z | xargs -0 sed -i -e 's/$OLD/$NEW/g'
}


function zj-reset() {
    mv ~/.cache/zellij/permissions.kdl .
    rm -rf ~/.cache/zellij/*
    mv permissions.kdl ~/.cache/zellij/permissions.kdl
}


function restart-plasma(){
    killall plasmashell
    plasmashell &
}

# insert audio with 500ms delay
# media-merge video.mp4 audio.mp4 00:00:00.500
function media-merge(){
    local video audio offset

    # replace audio for a video with an offset
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

function to-mp3(){
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

function to-ogg(){
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
function to-slack-gif() {
    local input out base scale fps

    input=${1:-"input.mp4"}
    if [ ! -f "$input" ]; then
        echo "No such file: $input"
    fi

    base="${input%.*}"
    out=${2:-"$base.gif"}
    scale=${3:-"128:-1"}
    fps=${4:-"10"}

    # for gif it's mostly fps
    ffmpeg -i "$input" \
        -vf "fps=${fps},scale=${scale}:flags=lanczos" \
        -c:v gif -b:v 64k \
        "$out"
    }

function resize-to-slack() {
    local input out base

    input=${1:-"input.mp4"}
    if [ ! -f "$input" ]; then
        echo "No such file: $input"
    fi

    base="${input%.*}"
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

# import .env
function import() {
    set -a
    source "$1"
    set +a
}

function docker-clean-all () {
    docker container prune -f
    docker image prune -f
    docker volume prune -f
}

function clean-rust () {
    find . -type d -name target -exec rm -rf {} + -o -type f -name Cargo.lock -exec rm -f {} +
}

# usage
# gifify -i <video> [-o OUTPUT] [-c CROP] [-f FPS] [-s SCALE] [-l LOOP]
function gifify() {
    set -e

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
                exit 0
                ;;
            *)  # positional input
                if [ -z "$input" ]; then
                    input="$1"
                else
                    echo "Unexpected positional argument: $1" >&2
                    exit 1
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
    ffmpeg -y -i ${input} -vf "$filters,palettegen" -update 1 "${palette_file}"
    ffmpeg -y -i "${input}" -i "${palette_file}" \
        -filter_complex "[0:v]${filters}[p];[p][1:v]paletteuse=dither=$dither" \
        -loop "$loop" "${output}"

    set +e
}

# normalize the name into kebab-case
# replace all spaces with -
# replace weird youtube ticks by normal ones
# clean up repeating dashes
#
# # example
# normalize <file> [prefix]
#
# ```bash
# normalize "Artes undead - --pilates.mp3"
# artes-undead-pilates.mp3
#
# ```
function normalize() {
    local normalize_name prefix temp
    normalize_name="$1"
    prefix=${2:-""}
    temp="$prefix$(echo "$normalize_name" | tr '[:upper:]' '[:lower:]' | \
        sed 's/ \[[^]]*\]//g' | \
        sed 's/[＂"]\|[＂"]//g' | \
        sed 's/\.-\| \./-/g' | \
        sed 's/\\//g' | \
        sed 's/ /-/g' | \
        sed 's/,/-/g' | \
        sed 's/-–-/-/g' | \
        sed 's/--/-/g' | \
        sed 's/&/and/g' | \
        sed 's/,-/-/g')"

    echo "$temp"
}

# prefix all, lowercase and remove anything that matches " \[[*]]*\]"
# which is a usual yt-dlp residual
# usage:
# prefix-all <the-group> [PATTERN]
function prefix-all(){
    local prefix patt new

    prefix=${1:-""}
    patt=${2:-"*"}
    echo "prefix $prefix"

    find . -name "$patt" -type f -print0 -exec bash -c '
    normalize() {
        local normalize_name prefix temp

        prefix=${2:-""}
        normalize_name=$(basename "$1")
        temp="$prefix$(echo "$normalize_name" | tr "[:upper:]" "[:lower:]" | \
            sed "s/ \[[^]]*\]//g" | \
            sed "s/[＂\"]\|[＂\"]//g" | \
            sed "s/\.-\| \./-/g" | \
            sed "s/ /-/g" | \
            sed "s/---/-/g; s/--/-/g" | \
            sed "s/-–-/-/g" | \
            sed "s/--/-/g" | \
            sed "s/_/-/g" | \
            sed "s/,-/-/g")"

        echo "$temp"

    }

new=$(normalize "$0" "$1")
mv -v "$0" "$new"' {} "$prefix" \;

# will create a lot of empty directories
find . -type d -print0 -empty -delete
}

# format-track -i in.wav -c my-cover.jpg
function format-track() {
    local input output title artist album ext cover genre style video key cmd default

    while [[ $# -gt 0 ]]; do
        set -e
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
                exit 0
                ;;
            *) # unknown option
                echo "Unknown option: $key"
                exit 0
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
function to-yt() {
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

# dumb screen tracker exploit for soulless corporate jobs I used to use as as a junior
function explore() {
    local rnds c WIDS id
    rnds=${1:-100}
    echo "rnds $rnds"

    for ((c=1; c<=rnds; c++)); do
        sleep 5
        WIDS=$(xdotool search --onlyvisible "gnome-terminal")
        xdotool search "Mozilla" windowactivate --sync
        sleep 540
        xdotool search "Visual Studio Code" windowactivate --sync

        for id in $WIDS; do
            sleep 540
            xdotool windowactivate "$id"
        done
        echo "done $c"
    done
    echo "done end"
}

function work_test() {
    local rnds c WIDS id
    rnds=${1:-3}
    echo "rnds $rnds"

    for ((c=1; c<=rnds; c++)); do
        sleep 5
        WIDS=$(xdotool search --onlyvisible "gnome-terminal")
        xdotool search "Mozilla" windowactivate --sync
        sleep 1
        xdotool search "Visual Studio Code" windowactivate --sync

        for id in $WIDS; do
            sleep 1
            xdotool windowactivate "$id"
        done
        echo "done $c"
    done
    echo "done end"
}

