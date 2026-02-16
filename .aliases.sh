#!/bin/bash

source ~/Documents/dotfiles/scripts/utils.sh
source ~/Documents/dotfiles/scripts/media.sh

# global stuff
alias fix-amd-gpu="sudo cat /sys/kernel/debug/dri/1/amdgpu_gpu_recover"
alias firefox="flatpak run --branch=stable --arch=x86_64 --command=firefox --file-forwarding org.mozilla.firefox"
alias restart-pipewire='systemctl --user restart pipewire.socket pipewire-pulse.socket wireplumber.service'
alias update-all='sh ~/Documents/dotfiles/update.sh'
alias dx-serve='BEVY_ASSET_ROOT=. dx serve --hot-patch'

# ffmpeg
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
alias yt='yt-dlp -x -t mp3'
alias rabbit-inspect='rabbitmqctl list_queues | grep -v -e "0"'
alias docker-container-rm-all-force='docker ps -q | xargs -I {} docker rm -f {}'
alias co-main='git checkout $(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name)'
alias speedtest='cat -p ~/Documents/py/speedtest.py | python -'
alias carla='flatpak run studio.kx.carla'
alias ardour='~/Sound/ardour-build/gtk2_ardour/ardev'

# zellij hotkeys
alias zj="zellij"
alias zjm="zj attach main || zj -s main -n main"
alias zjs="zj attach simple || zj -s simple -n simple"
alias zjl="zj attach lmms || zj -s lmms -n lmms"
alias zja="zj attach ardour || zj -s ardour -n ardour"

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

# alias bored="nmap -Pn -sS -p 80 -iR 0 --open"
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

export OLLAMA_CONTEXT_LENGTH=64000
export SYSTEMD_EDITOR=nvim
