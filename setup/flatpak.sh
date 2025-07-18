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

# browser
flatpak install -y flathub org.mozilla.firefox

# vpn
flatpak install -y flathub com.surfshark.Surfshark

# libre office
flatpak install -y flathub org.libreoffice.LibreOffice

# airshipper
flatpak install -y flathub net.veloren.airshipper

# OBS
flatpak install -y flathub com.obsproject.Studio

# peek gif recorder
flatpak install -y flathub com.uploadedlobster.peek

# telegram
flatpak install -y flathub org.telegram.desktop

# discord
flatpak install -y flathub com.discordapp.Discord

# steam
flatpak install -y flathub com.valvesoftware.Steam

# pixelart editor
flatpak install -y flathub com.orama_interactive.Pixelorama

# Blender
flatpak install -y flathub org.blender.Blender

# Orion torrent streamer
flatpak install -y flathub com.ktechpit.orion

# carla audio host for windows vst plugins
flatpak install -y flathub studio.kx.carla

# recording
flatpak install -y flathub org.audacityteam.Audacity

# Reaper
flatpak install -y flathub fm.reaper.Reaper

# KDE photodshop
flatpak install -y flathub org.kde.krita

# screenshots if spectacle not available
#flatpak install -y flathub org.flameshot.Flameshot

# Godot engine
# flatpak install -y flathub org.godotengine.Godot

# DAW
# flatpak install -y flathub com.bitwig.BitwigStudio

# mic effects
flatpak install -y flathub com.github.wwmm.easyeffects

# midid virtual hub
# flatpak install -y flathub xyz.safeworlds.midiconn

# slack
# flatpak install flathub com.slack.Slack
# give slack permission to pictures
# sudo flatpak override --filesystem=home/Pictures:ro com.slack.Slack

# vscode
# flatpak install flathub com.visualstudio.code

