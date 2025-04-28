#!/bin/bash

# update system packages
sudo apt update
sudo apt upgrade -y

# update flatpak packages
flatpak update -y

# update nvim packages with lazy
nvim --headless +"lua require('lazy').sync()" +qa
