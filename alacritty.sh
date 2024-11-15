#!/bin/bash

git clone https://github.com/alacritty/alacritty

cd alacritty

sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y

cargo build --release

# terminfo
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

# change default terminal
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /home/pickle/.cargo/bin/alacritty 50

# To check this should point to alacritty auto
# sudo update-alternatives --config x-terminal-emulator

# Desktop support
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

# shell completions
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty

# copy config file
cp alacritty.yml ~/.config/alacritty/alacritty.yml

cd ..
rm -rf alacritty
