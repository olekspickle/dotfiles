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

function mp4-to-mp3(){
    ffmpeg -i $1 -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 $2
}

function wav-to-ogg(){
    find . -name "*.wav" -exec ffmpeg -i {} -acodec libvorbis {}.ogg \;
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

function to-ogg-all () {
    path=${1:-"."}
    ext=${1:-"mp4"}
    for file in "${path}/*.${ext}"; do
        if [[ -f "$file" ]]; then
            filename="${file%.*}"
            ffmpeg -i "$file" -vn -acodec libvorbis -aq 5 "${filename}.ogg"
        fi
    done
}

function docker-clean-all () {
    docker container prune -f
    docker image prune -f
    docker volume prune -f
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
    f=${1:-""}
    prefix=${2:-""}
    new="$prefix$(echo "$f" | tr '[:upper:]' '[:lower:]' | \
        sed 's/ \[[^]]*\]//g' | \
        sed 's/[＂"]\|[＂"]//g' | \
        sed 's/\.-\| \./-/g' | \
        sed 's/ /-/g' | \
        sed 's/---/-/g; s/--/-/g' | \
        sed 's/-–-/-/g' | \
        sed 's/--/-/g' | \
        sed 's/,-/-/g')"

    echo "$new"
}

# rename all files in directory
function rename-all() {
    for f in $(find . -type f);
    do
        new=$(normalize "$f")
        mv -v "$f" "${new/$1/$2}"
    done
}

# prefix all, lowercase and remove anything that matches " \[[*]]*\]"
# which is a usual yt-dlp residual
# usage:
# prefix-all <the-group>
function prefix-all(){
    prefix=${1:-""}
    if [ -n "$prefix" ];
    then
        prefix="$prefix-";
    fi
    echo "prefix $prefix"

    for f in $(find . -type f);
    do
        new=$(normalize "$f" "$prefix")
        echo "$f -> $new"
        mv -v "$f" "$new";
    done
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

# Clean log from colors
alias cleanup="sed 's/\x1b\[[0-9;]*m//g'"

# oxidize
alias cat='bat'
alias fd='fdfind'

alias adbsync='~/.venv/bin/adbsync'
alias 'yt'='yt-dlp -x --audio-format mp3'
alias rabbit-inspect='rabbitmqctl list_queues | grep -v -e "0"'
alias docker-container-rm-all-force='docker ps -q | xargs -I {} docker rm -f {}'
alias co-main='git checkout $(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name)'
alias speedtest='cat ~/Documents/py/speedtest.py | python -'

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
alias remote-copy='rsync -avzh --progress -e "ssh -i ~/.ssh/pickle.pem" $1  $2:~/'

# Alias for aws command that connects to localstack instead of real AWS server
alias aws-local="aws --endpoint-url http://127.0.0.1:4566"


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# pretty xev
alias xev-pretty="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"



# dumb screen tracker exploit
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

