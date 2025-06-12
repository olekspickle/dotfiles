#!/bin/bash

function rot13() {
    cat | tr "$(echo -n {A..Z} {a..z} | tr -d ' ')" "$(echo -n {N..Z} {A..M} {n..z} {a..m} | tr -d ' ')"
}

function wargames() {
    ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password  -p 2220 "$1"@bandit.labs.overthewire.org
}

function git-reset-author() {
    git rebase -r --root --exec 'git commit --amend --no-edit --reset-author'
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

function webm-all-to-mp3(){
    find . -type f -iname "*.webm" -exec bash -c 'FILE="$1"; ffmpeg -i "${FILE}" -vn -ab 128k -ar 44100 -y "${FILE%.webm}.mp3";' _ '{}' \;
}

function media-merge(){
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

function mp4-to-mp3(){
    ffmpeg -i $1 -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 $2
}

# for quality control -aq flag can be added
# 1(quality) > 4(default > 9(compressed)
# to-ogg mp4
function to-ogg(){
    ext=${1:-"wav"}
    find . -name "*.$ext" -print0 -exec sh -c 'filename=${0%.*}; ffmpeg -y -i "$0" -vn -ac 2 -c:a libvorbis -q:a 10 "$filename.ogg"' {} \;
}

function to-slack-gif() {
    # for gif it's mostly fps
    ffmpeg -i $1 -vf "fps=10,scale=128:128:flags=lanczos" -c:v gif -b:v 256k $2
}

function resize-to-slack() {
    # -c:v libx264: This option sets the efficient video codec to H.264
    # -crf 28: The Constant Rate Factor (CRF) determines the video quality
    # A lower value results in higher quality but larger file size. moderate - 28
    # -preset slow: This preset option controls the encoding speed and quality trade-off.
    # The "slow" preset provides better compression efficiency, but it's slower.
    # If you want faster encoding, you can choose a different preset like "medium" or "fast".
    # -c:a aac -b:a 128k: These options specify the audio codec as AAC and set the audio bitrate to 128kbps.
    ffmpeg -i $1 -vf "scale=128:128" -c:v libx264 -crf 28 -preset slow -c:a aac -b:a 128k $2
}

function import() {
    set -a
    source $1
    set +a
}

function docker-clean-all () {
    docker container prune -f
    docker image prune -f
    docker volume prune -f
}

# usage
# gifify -i <video> [-o OUTPUT] [-c CROP] [-f FPS] [-s SCALE] [-l LOOP]
function gifify() {
    set -ex

    # Reset variables so that sequential runs with positional arg do not crash
    input=""

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
                echo "-i,--input    input path"
                echo "-o,--output   output path"
                echo "-f,--fps      filter sets the frame rate"
                echo "-s,--scale    scale filter will resize the output to 320 pixels wide and automatically determine the height while preserving the aspect ratio. The lanczos scaling algorithm is used in this example. example: 640:-1"
                echo "-c,--crop     example: 'iw-100:ih' to crop 100px horizontally(50 from each side)"
                echo "-l,--loop     Control looping with -loop output option but the values are confusing. A value of 0 is infinite looping, -1 is no looping, and 1 will loop once meaning it will play twice. So a value of 10 will cause the GIF to play 11 times"
                exit 0
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

    if [ -z "$fps" ]; then
        fps="24"
    fi

    if [ -z "$loop" ]; then
        loop="0"
    fi

    # create directory with png frames with random 4 alphanumeric char suffix
    # current=$(pwd)
    # tmpd=$(mktemp -d)
    # mkdir -p "$tmpd" && cd $_

    echo "saving png frames with base: $base"
    # palettegen    https://ffmpeg.org/ffmpeg-filters.html#palettegen
    # paletteuse    https://ffmpeg.org/ffmpeg-filters.html#paletteuse
    # split         https://ffmpeg.org/ffmpeg-filters.html#split_002c-asplit
    # ffmpeg -i "${current}/${input}" \
    ffmpeg -i "${input}" \
        -vf "fps=$fps$crop,scale=$scale\:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
        -loop "$loop" "${base}.gif"
    # "${base}-frame%04d.png"
    # echo "saving final $output and cleaning up"
    # gifski -o "../$output" "$base-frame*png"
    #
    # cd "$current"

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
    local normalize_name="$1"
    local prefix=${2:-""}

    local temp="$prefix$(echo "$normalize_name" | tr '[:upper:]' '[:lower:]' | \
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
    prefix=${1:-""}
    patt=${2:-"*"}
    echo "prefix $prefix"

    find . -name "$patt" -type f -print0 -exec bash -c '
    normalize() {
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

#git-rename
function git-rename() {
    OLD=${1:- };
    NEW=${2:- };
    echo old: $OLD new: $NEW;
    git ls-files -z | xargs -0 sed -i -e 's/$OLD/$NEW/g'
}

# show logs without weird sequences
# sudo apt install colorized-logs
function logless(){
    ansi2txt < $1 | less
}

function strip-logs() {
    # Strips all escape sequences and control codes from stdin.
    cat $1 | sed -e 's,[\x00-\x08\x0E-\x1F]\|\x1B\(\[[0-?]*[ -/]*[@-~]\),,g' > $2
}

# global stuff
alias firefox="flatpak run --branch=stable --arch=x86_64 --command=firefox --file-forwarding org.mozilla.firefox"
alias restart-pipewire='systemctl --user restart pipewire.socket pipewire-pulse.socket wireplumber.service'
alias update-all='sh ~/Documents/dotfiles/update.sh'
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'
# Clean log from colors
alias cleanup="sed 's/\x1b\[[0-9;]*m//g'"
# sudo not knowing aliases workaround
alias sudo='sudo '
# oxidize
alias cat='bat'
alias fd='fdfind'
alias "carg orun"='cargo run'

alias virtualenv="uv venv"
alias adbsync='~/.venv/bin/adbsync'
alias yt='yt-dlp -x --audio-format mp3'
alias rabbit-inspect='rabbitmqctl list_queues | grep -v -e "0"'
alias docker-container-rm-all-force='docker ps -q | xargs -I {} docker rm -f {}'
alias co-main='git checkout $(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name)'
alias speedtest='cat ~/Documents/py/speedtest.py | python -'
alias carla='flatpak run studio.kx.carla'

# zellij hotkeys
alias zj="zellij"
alias zjp="zj -s ollama -l pi || zj attach ollama"
alias zjm="zj -s main -n main || zj attach main"
alias zjs="zj -s simple -n simple || zj attach simple"

alias vim="nvim"
alias vi="nvim"
alias python='python3'

# cp-remote root@192.168.0.1 ~/remote/path local/path
alias cp-remote="rsync -avzh --progress -e 'ssh -i ~/.ssh/id_ed25519'  $1 $2"

alias gbb="git bb"
alias gb="git branch"
alias gc="git checkout"
alias ga="git add"
alias gd="git diff"
alias gs="git status"
alias tf="terraform"

alias bored="nmap -Pn -sS -p 80 -iR 0 --open"
alias battery="upower -i `upower -e | grep 'BAT'`"
alias bombard="docker run -ti --rm alpine/bombardier -c 1000 -d 3600s -l $1"

alias myip="curl http://ipecho.net/plain; echo"
#musl
alias rust-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder'

# EC2 instance rsync
# example: remote-copy some_dir remote_user@address.com

# Connect my droplet
alias botinok="ssh -i ~/.ssh/id_rsa root@167.172.97.246"
alias remote-copy='rsync -avzh --progress -e "ssh -i ~/.ssh/pickle.pem" $1  $2:~/'

# Alias for aws command that connects to localstack instead of real AWS server
alias aws-local="aws --endpoint-url http://127.0.0.1:4566"


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# pretty xev
alias xev-pretty="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"



# dumb screen tracker exploit for soulless corporate jobs
alias explore='
rnds=${1:-100};
echo "rnds" $rnds
for ((c=1; c<=$rnds; c++ ));
do
    sleep 5;
    WIDS=`xdotool search --onlyvisible "gnome-terminal"`;
    xdotool search "Mozilla" windowactivate --sync;
    sleep 540;
    xdotool search "Visual Studio Code" windowactivate --sync;
    for id in $WIDS;
    do
        sleep 540;
        xdotool windowactivate $id;
    done;
    echo "done $c"
done
echo "done end"
'
alias work_test='
rnds=${1:-3};
echo "rnds" $rnds
for ((c=1; c<=$rnds; c++ ));
do
    sleep 5;
    WIDS=`xdotool search --onlyvisible "gnome-terminal"`;
    xdotool search "Mozilla" windowactivate --sync;
    sleep 1;
    xdotool search "Visual Studio Code" windowactivate --sync;
    for id in $WIDS;
    do
        sleep 1;
        xdotool windowactivate $id;
    done;
    echo "done $c"
done
echo "done end"

'
# format-track -i in.wav -c my-cover.jpg
function format-track() {
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
                shift # past argument
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
        else
            if [[ "$video" == "true" ]];then
                echo "video output selected but no video input provided"
            fi
        fi
    fi
    if [[ -n "$cover" && "$cover" != "0" ]]; then
        echo "cover image: $cover"
        if [[ "$video" ]]; then
            cmd+=(-loop 1 -r 1)
        fi
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
            -codec:a libmp3lame -b:a 128k -vn -qscale:a 2  \
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
    out="${1%.*}"
    ffmpeg -y -loop 1 -r 1 -i $2 -i $1 -c:a copy -shortest -c:v libx264 "$out.mp4"
}
