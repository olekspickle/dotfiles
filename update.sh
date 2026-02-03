#!/bin/bash

# update system packages
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

# update flatpak packages
flatpak update -y

# update rust, mostly to sync nightly
rustup update

# update nvim packages with lazy
nvim --headless +"lua require('lazy').sync()" +qa

fwupdmgr get-updates && fwupdmgr update
