#!/bin/bash

HOME=${HOME:-/home/pickle}
BACKUP_DIR="/var/backups"

sudo rsync -avzh --delete "$HOME"/.local/share/fonts "$HOME"/Documents
# backup most of the data
sudo rsync -avzh --delete "$HOME/Documents/" "$BACKUP_DIR/Documents/" \
    --exclude "*/target/*" \
    --exclude "*/logs/*" \
    --exclude "*.venv*" \
    --exclude "*.mypy_cache*" \
    --exclude "*/node_modules/*"
sudo rsync -avzh --delete "$HOME/Downloads/" "$BACKUP_DIR/Downloads/" \
    --exclude "*Orion*" --exclude "*elegram*" --max-size=1G
sudo rsync -avzh --delete "$HOME/Videos/" "$BACKUP_DIR/Videos/" --exclude "*Camera*"
sudo rsync -avzh --delete "$HOME/Pictures/" "$BACKUP_DIR/Pictures/"
sudo rsync -avzh --delete "$HOME/Sound/" "$BACKUP_DIR/Sound/"  --exclude "*gdc*"
sudo rsync -avzh --delete "$HOME/Music/" "$BACKUP_DIR/Music/" --max-size=300M
sudo rsync -avzh --delete "$HOME/Games/" "$BACKUP_DIR/Games/" \
    --exclude "*/target/*" --exclude "*.godot*"  --exclude "*UE*"

# dotfiles
nvim_sync=("$HOME/Documents/dotfiles/setup/nvim.sh" "--sync")
"${nvim_sync[@]}"

rsync -avzh "$HOME"/.aws "$HOME"/Documents/dotfiles
rsync -avzh "$HOME"/.aliases.sh "$HOME"/Documents/dotfiles
rsync -avzh "$HOME"/.gitconfig "$HOME"/Documents/dotfiles
rsync -avzh "$HOME"/.ssh/config "$HOME"/Documents/dotfiles/.ssh
rsync -avzh "$HOME"/.config/htop "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/starship.toml "$HOME"/Documents/dotfiles/.config
rsync -avzh --delete "$HOME"/.config/alacritty "$HOME"/Documents/dotfiles/.config
rsync -avzh --delete "$HOME"/.config/zellij "$HOME"/Documents/dotfiles/.config
rsync -avzh --delete "$HOME"/.config/atuin "$HOME"/Documents/dotfiles/.config --exclude ".*"

# KDE
rsync -avzh "$HOME"/.config/kdeglobals "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/plasmarc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/plasma-org.kde.plasma.desktop-appletsrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/plasma-workspace/env "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/kwinrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/kxkbrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/kwinrulesrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/krunnerrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/kscreenlockerrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/khotkeysrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/kglobalshortcutsrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/ksplashrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/dolphinrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/powermanagementprofilesrc "$HOME"/Documents/dotfiles/.config

