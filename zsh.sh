#! /bin/bash 

set -euo pipefail; shopt -s failglob # safe mode

echo "Installing zsh..."
sudo apt install zsh

echo "Zsh Version:"
zsh --version

echo "Set zsh as default shell"
chsh -s $(which zsh)

echo $SHELL

$SHELL --version

echo "Install Oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
