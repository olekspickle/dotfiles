#!/bin/bash

sudo apt update
sudo apt install python3-dev python3-pip python3-setuptools
pipx install thefuck
cat "eval '$(thefuck --alias)'" >> ~/.bashrc
