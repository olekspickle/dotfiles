#!/bin/bash

set -e
echo Installing flatpak...
sudo apt install flatpak
flatpak remote-add -y --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# flatseal to manage flatpak permissions
flatpak install -y flathub com.github.tchx84.Flatseal

# firefox browser
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

# vpn
flatpak install -y flathub com.surfshark.Surfshark

# libre office
flatpak install -y flathub org.libreoffice.LibreOffice

# power management
sudo apt install tlp
sudo systemctl enable tlp --now
flatpak install flathub com.github.d4nj1.tlpui

# telegram
flatpak install -y flathub org.telegram.desktop

# discord
# flatpak install -y flathub com.discordapp.Discord

# steam
flatpak install -y flathub com.valvesoftware.Steam

# airshipper
flatpak install -y flathub net.veloren.airshipper

# Orion torrent streamer
flatpak install -y flathub com.ktechpit.orion

# recording
flatpak install -y flathub org.audacityteam.Audacity

# carla audio host for windows vst plugins
flatpak install -y flathub studio.kx.carla

# mic effects
flatpak install -y flathub com.github.wwmm.easyeffects

# pixelart editor
flatpak install -y flathub com.orama_interactive.Pixelorama

# KDE photodshop
flatpak install -y flathub org.kde.krita

# OBS screen recorder
flatpak install -y flathub com.obsproject.Studio

# video editor
flatpak install flathub org.kde.kdenlive

# Blender
flatpak install -y flathub org.blender.Blender

# 3D slicer for printer
flatpak install flathub com.ultimaker.cura

# screenshots if spectacle not available
#flatpak install -y flathub org.flameshot.Flameshot

# peek gif recorder
flatpak install -y flathub com.uploadedlobster.peek


# matrix client
# flatpak install flathub im.riot.Riot

# Reaper
# flatpak install -y flathub fm.reaper.Reaper

# Godot engine
# flatpak install -y flathub org.godotengine.Godot

# DAW
# flatpak install -y flathub com.bitwig.BitwigStudio

# midid virtual hub
# flatpak install -y flathub xyz.safeworlds.midiconn

# slack
# flatpak install flathub com.slack.Slack
# give slack permission to pictures
# sudo flatpak override --filesystem=home/Pictures:ro com.slack.Slack

# vscode
# flatpak install flathub com.visualstudio.code

