#!/bin/bash

# New full machine setup
# ideally - media should already be copied to $HOME/Pictures

# make all .sh scripts executable
find . -type f -name "*.sh" -exec chmod +x {} \;

echo "Installing basic tools..."
sudo apt install pkg-config build-essential curl cmake lld coreutils xclip \
    libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev \
    libpcap-dev libasound2-dev libgtk-3-dev \
    fonts-firacode fonts-powerline nmap\
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
rsync -avzh .config/* ~/.config
rsync -avzh .aws ~/
cat bashrc -p >> ~/.bashrc
cp .aliases ~/.aliases

