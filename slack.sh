#!/bin/bash

set -e

# install slack
flatpak install flathub com.slack.Slack

# give slack permission to pictures
sudo flatpak override --filesystem=home/Pictures:ro com.slack.Slack
