#!/bin/bash

# image metadata edition and ffmpeg
sudo apt install -y libimage-exiftool-perl checkinstall imagemagick \
    ffmpeg lame

# OBS
sudo apt install v4l2loopback-dkms
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio
