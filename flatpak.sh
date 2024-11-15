#!/bin/bash

set -e
echo Installing flatpak...
# install flatpak
sudo apt install flatpak
# add flathub repo
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
