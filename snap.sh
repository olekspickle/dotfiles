#!/bin/bash

set -euo pipefail; shopt -s failglob # safe mode 

sudo snap install code --classic
cp vscode-settings ~/.config/Code/User/settings.json

