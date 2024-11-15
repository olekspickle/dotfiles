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

echo "Install powerlevel9k theme..."
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

echo "ZSH_THEME=powerlevel9k/powerlevel9k" >> ~/.zshrc

echo "POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vcs dir rbenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(root_indicator background_jobs status load)" >> ~/.zshrc

echo Install zsh zsh-autosuggestions...
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Manually add the plugin to the list of plugins for Oh My Zsh to load (inside ~/.zshrc):
#
# plugins=(
#     # other plugins...
#     zsh-autosuggestions
# )
