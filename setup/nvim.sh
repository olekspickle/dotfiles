#!/bin/bash

# Check if the "--sync" flag is present
# ./nvim --sync
if [[ "$*" == *"--sync"* ]]; then
    rsync -avzh --delete ~/.config/nvim .config --exclude="*site" --exclude="*plugin" --exclude="*lazy*"
    exit 0;
fi

if [ -d "/squashfs-root" ]; then
   rm -rf /squashfs-root
   rm /usr/bin/nvim
fi

if [ ! -f "nvim.appimage" ]; then
    echo "Downloading nvim.appimage..."
    curl -sL -o nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod u+x nvim.appimage
fi

./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version

# Optional: exposing nvim globally.
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

# Optional: add nvim to default editors if not present
if ! sudo update-alternatives --list editor 2>/dev/null | rg -q nvim; then
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 100
fi

# clean up
rm -f ./nvim.appimage

