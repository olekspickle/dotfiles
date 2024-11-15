#!/bin/bash

# New full machine setup
# ideally - media should already be copied to $HOME/Pictures

echo "Installing basic tools..."
sudo apt install pkg-config build-essential curl cmake lld coreutils \
    libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev \
    fonts-firacode fonts-powerline \
    -y

# utils for setup
echo "Installing python..."
./setup/python.sh

# runtimes and compilers
echo "Installing node..."
./setup/node.sh
echo "Installing rust..."
./setup/rust/lang.sh

# terminal
echo "Installing alacritty terminal emulator..."
./setup/alacritty.sh
echo "Installing zsh shell..."
./setup/zsh.sh
echo "Installing starship prompt..."
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -y
echo "Installing neovim..."
./setup/nvim.sh
echo "Installing fonts..."
./setup/fonts.sh

echo "Installing media related tools..."
./setup/media.sh
echo "Installing rusty packages..."
./setup/rust/oxidized_packages.sh

# copy configuration and aliases
rsync -avzh .config/* ~/.config
rsync -avzh .aws ~/
cat bashrc -p >> ~/.bashrc
cp .aliases ~/.aliases

