#!/bin/bash

# some scripts are dependent on previous,
# so follow exit in case of any error
set -e

# New full machine setup
# ideally - media should already be copied to $HOME/Pictures

# make all .sh scripts executable
find . -type f -name "*.sh" -exec chmod 744 {} \;

echo "Installing basic tools for Wayland KDE..."
sudo apt install wl-clipboard pkg-config build-essential curl llvm \
    cmake lld coreutils colorized-logs \
    libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev libudev-dev \
    libpcap-dev libasound2-dev libgtk-3-dev \
    fonts-firacode fonts-powerline nmap yamllint\
    -y

# utils for setup
echo "Installing python..."
./setup/python.sh

# runtimes and compilers
echo "Installing node..."
./setup/node.sh
echo "Installing rust..."
./setup/rust/lang.sh
echo "Installing rusty packages..."
./setup/rust/oxidized_packages.sh

# terminal
echo "Installing alacritty terminal emulator..."
./setup/alacritty.sh
echo "Installing zsh shell..."
./setup/zsh.sh
echo "Installing neovim..."
./setup/nvim.sh
echo "Installing fonts..."
./setup/fonts.sh

echo "Installing media related tools..."
./setup/media.sh

# copy configuration and aliases
rsync -avzh .config ~/
rsync -avzh .aws ~/
rsync -avzh .ssh ~/
cp .aliases.sh ~/.aliases.sh

