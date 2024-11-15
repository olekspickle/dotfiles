#!/bin/bash

# Check if the "--sync" flag is present
# ./nvim --sync
if [[ "$*" == *"--sync"* ]]; then
    rsync -avzh ~/.config/nvim .config --exclude="*site" --exclude="*plugin" --exclude="*lazy*"
    exit 0;
fi

if [ -d "/squashfs-root" ]; then
    rm -rf /squashfs-root
    rm /usr/bin/nvim
fi

if [ ! -f "nvim.appimage" ]; then
    curl -sLO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
fi

./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version

# Optional: exposing nvim globally.
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

# clean up
rm ./nvim.appimage

