#!/bin/bash

set -e
echo Installing flatpak...
# install flatpak
sudo apt install flatpak
# add flathub repo
flatpak remote-add -y --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# flatseal to manage flatpak permissions
flatpak install -y flathub com.github.tchx84.Flatseal

# firefox
# check if there is snap block mounted
lsblk -fe7 -o+ro | rg firefox
case $? in
    0)
        sudo systemctl stop var-snap-firefox-common-host\\x2dhunspell.mount
        sudo systemctl disable var-snap-firefox-common-host\\x2dhunspell.mount
        ;;
    *)
        echo "Command failed: Minor errors."
        ;;
esac
# purge snap package
snap disable firefox
sudo snap remove --purge firefox

flatpak install -y flathub org.mozilla.firefox

# libre office
flatpak install -y flathub org.libreoffice.LibreOffice

# screenshots
flatpak install flathub org.flameshot.Flameshot

# airshipper
flatpak install -y flathub net.veloren.airshipper

# carla audio host for windows vst plugins
flatpak install flathub studio.kx.carla

# OBS
flatpak install -y flathub com.obsproject.Studio

# discord
flatpak install -y flathub com.discordapp.Discord

# steam
flatpak install -y flathub com.valvesoftware.Steam

# Godot engine
flatpak install -y flathub org.godotengine.Godot

# Orion torrent streamer
flatpak install flathub com.ktechpit.orion

# mic effects
flatpak install flathub com.github.wwmm.easyeffects

# telegram
flatpak install flathub org.telegram.desktop

# pixelart editor
flatpak install flathub com.orama_interactive.Pixelorama

# slack
# flatpak install flathub com.slack.Slack
# give slack permission to pictures
# sudo flatpak override --filesystem=home/Pictures:ro com.slack.Slack

# vscode
# flatpak install flathub com.visualstudio.code

