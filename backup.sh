#!/bin/bash

set -e

HOME=${HOME:-/home/pickle}

BACKUP_DIR="/var/backups"
CFG_DIR="$HOME/.config"
DOT_DIR="$HOME/Documents/dotfiles"
COMMON_EXCLUDES=(
    "--exclude" "*Camera*"
    "--exclude" "*target*"
    "--exclude" "*logs*"
    "--exclude" "*venv*"
    "--exclude" "*mypy_cache*"
    "--exclude" "*node_modules*"
    "--exclude" "*build*"
    "--exclude" "*gdc*"
    "--exclude" "*fort*"
    "--exclude" "*godot*"
)

rsync_() {
    sudo rsync -avzh --delete "$@" "${COMMON_EXCLUDES[@]}"
}

rsync_ "$HOME"/.local/share/fonts "$HOME"/Documents
# backup most of the data
rsync_ "$HOME/Pictures/" "$BACKUP_DIR/Pictures/"
rsync_ "$HOME/Downloads/" "$BACKUP_DIR/Downloads/" --max-size=100M
rsync_ "$HOME/Videos/" "$BACKUP_DIR/Videos/"
rsync_ "$HOME/Music/" "$BACKUP_DIR/Music/" --max-size=300M
rsync_ "$HOME/Sound/" "$BACKUP_DIR/Sound/"
rsync_ "$HOME/Games/" "$BACKUP_DIR/Games/"
rsync_ "$HOME/Documents/" "$BACKUP_DIR/Documents/"

# dotfiles
nvim_sync=("$HOME/Documents/dotfiles/setup/nvim.sh" "--sync")
"${nvim_sync[@]}"

rsync_ "$HOME"/.aws "$DOT_DIR"
rsync_ "$HOME"/.gitconfig "$DOT_DIR"
rsync_ "$HOME"/.ssh/config "$DOT_DIR"/.ssh
rsync_ "$HOME"/.cargo/config.toml "$DOT_DIR"/.cargo/config.toml
rsync_ "$CFG_DIR"/starship.toml "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/alacritty "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/zellij "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/atuin "$DOT_DIR"/.config --exclude ".*"
rsync_ "$CFG_DIR"/btop/btop.conf "$DOT_DIR"/.config/btop

# agent setup
OPENCODE_DIR="$CFG_DIR"/opencode
rsync_ "$OPENCODE_DIR"/opencode.json "$DOT_DIR"/.config/opencode/opencode.json
rsync_ "$OPENCODE_DIR"/opencode.local.json "$DOT_DIR"/.config/opencode/opencode.local.json
rsync_ "$OPENCODE_DIR"/AGENTS.md "$DOT_DIR"/.config/opencode/AGENTS.md
rsync_ "$OPENCODE_DIR"/agents "$DOT_DIR"/.config/opencode

# KDE
rsync_ "$CFG_DIR"/kdeglobals "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/plasmarc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/plasma-org.kde.plasma.desktop-appletsrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/plasma-workspace/env "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/kwinrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/kxkbrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/kwinrulesrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/krunnerrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/kscreenlockerrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/khotkeysrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/kglobalshortcutsrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/ksplashrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/dolphinrc "$DOT_DIR"/.config
rsync_ "$CFG_DIR"/powermanagementprofilesrc "$DOT_DIR"/.config

set +e
