#!/bin/bash

#set -e

#git clone https://github.com/alacritty/alacritty

cd alacritty

sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y

cargo build --release

# terminfo
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

# To check this should point to alacritty auto
# sudo update-alternatives --config x-terminal-emulator

path="/usr/local/bin"

# Desktop support
sudo cp target/release/alacritty $path
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

# change default terminal
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator  $path 50
sudo chown root:root $path
sudo chmod --reference=/usr/bin/ls $path

# shell completions
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty

cd ..

mkdir ~/.config/alacritty

# copy config file
cp alacritty.yml ~/.config/alacritty/alacritty.yml

rm -rf alacritty

echo "Done! Alacritty is your terminal emulator now. It's good to have you back! A."
