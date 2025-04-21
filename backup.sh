#!/bin/bash

# clear previous buckups
sudo rm -rf /var/backups/Documents
sudo rm -rf /var/backups/Downloads
sudo rm -rf /var/backups/Videos
sudo rm -rf /var/backups/Pictures
sudo rm -rf /var/backups/Sound
sudo rm -rf /var/backups/Games

# backup most of the data
sudo rsync -avzh "$HOME"/Documents /var/backups \
    --exclude "*/target/*" \
    --exclude "*/Fyrox/*" \
    --exclude "*/logs/*" \
    --exclude "*.venv*" \
    --exclude "*.mypy_cache*" \
    --exclude "*/node_modules/*" \
    --max-size=5M

sudo rsync -avzh "$HOME"/Downloads /var/backups \
    --exclude "*Orion*" --exclude "*elegram*" --max-size=5M
sudo rsync -avzh "$HOME"/Videos/obs /var/backups/Videos --max-size=5M
sudo rsync -avzh "$HOME"/Pictures /var/backups --max-size=10M --exclude "*Camera*"
sudo rsync -avzh "$HOME"/Sound /var/backups --max-size=5M --exclude "*samples*"
sudo rsync -avzh "$HOME"/Games /var/backups --max-size=5M \
    --exclude "*samples*" --exclude "*/target/*" --exclude "*.godot*"

# dotfiles
nvim_sync=("$HOME/Documents/dotfiles/setup/nvim.sh" "--sync")
"${nvim_sync[@]}"
rsync -avzh "$HOME"/.aws "$HOME"/Documents/dotfiles
rsync -avzh "$HOME"/.aliases.sh "$HOME"/Documents/dotfiles
rsync -avzh "$HOME"/.gitconfig "$HOME"/Documents/dotfiles
rsync -avzh "$HOME"/.ssh/config "$HOME"/Documents/dotfiles/.ssh
rsync -avzh "$HOME"/.config/alacritty "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/starship.toml "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/zellij "$HOME"/Documents/dotfiles/.config
>>>>>>> 278f21b (add clipboard for wayland installation; cleanup redundant stuff; migrate alacritty)
rsync -avzh "$HOME"/.config/atuin "$HOME"/Documents/dotfiles/.config --exclude ".*"

# KDE
rsync -avzh "$HOME"/.config/kdeglobals "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/plasmarc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/plasma-workspace/env "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/kwinrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/krunnerrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/kscreenlockerrc "$HOME"/Documents/dotfiles/.config
rsync -avzh "$HOME"/.config/khotkeysrc "$HOME"/Documents/dotfiles/.config

