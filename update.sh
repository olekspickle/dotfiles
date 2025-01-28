#!/bin/bash

# update flatpak packages
flatpak update -y

# update system packages
sudo apt update
sudo apt upgrade

# update nvim packages with lazy
nvim +"lua require('lazy').sync()" --headless +qa
