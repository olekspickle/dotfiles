#!/bin/bash

# clear previous buckups
sudo rm -rf /var/backups/Documents
sudo rm -rf /var/backups/Downloads
sudo rm -rf /var/backups/Videos
sudo rm -rf /var/backups/Pictures
sudo rm -rf /var/backups/lmms

# backup most of the data
sudo rsync -avzh "$HOME"/Documents /var/backups \
    --exclude "*/zellij/*" \
    --exclude "*/Fyrox/*" \
    --exclude "*/logs/*" \
    --exclude "*.venv*" \
    --exclude "*/target/*" \
    --exclude "*.mypy_cache*" \
    --exclude "*/node_modules/*" \
    --max-size=5M

sudo rsync -avzh "$HOME"/Downloads /var/backups --exclude "*elegram*" --max-size=5M
sudo rsync -avzh "$HOME"/Videos/obs /var/backups/Videos --max-size=5M
sudo rsync -avzh "$HOME"/Pictures /var/backups --max-size=10M
sudo rsync -avzh "$HOME"/lmms /var/backups --max-size=15M

# dotfiles
rsync -avzh "$HOME"/.config/nvim "$HOME"/Documents/dotfiles/.config --exclude "*lazy-lock*"
rsync -avzh "$HOME"/.config/alacritty "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/starship.toml "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/zellij "$HOME"/Documents/dotfiles/.config \
    --exclude "main*" --exclude "beasts*" --exclude "*plugins*"
rsync -avzh "$HOME"/.config/atuin "$HOME"/Documents/dotfiles/.config --exclude ".*"

# KDE
rsync -avzh "$HOME"/.config/kdeglobals "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/plasmarc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/plasma-workspace/env "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/kwinrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/krunnerrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/kscreenlockerrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/khotkeysrc "$HOME"/Documents/dotfiles/.config

