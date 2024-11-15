#! /bin/bash 

set -euo pipefail; shopt -s failglob # safe mode

echo "Installing starship..."
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -y

echo `
eval "$(starship init zsh)"
# starship char leftover override
export LC_CTYPE=en_US.UTF-8
` >> ~/.zshrc

