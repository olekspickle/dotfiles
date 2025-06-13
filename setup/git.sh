#!/bin/bash

# add git goodness

# beautiful git branch table representation
git config --global alias.bb !"$HOME"/Documents/dotfiles/scripts/git-better-branch.sh

# record the resolution for easier rebases
git config --global rerere.enabled true

# better git branch by default: columned and sorted
git config --global column.ui auto
git config --global branch.sort -committerdate

# setup ssh signature for signed commits
git config --global gpg.format ssh
git config --global user.signingkey "$HOME"/.ssh/pickle_ed25519.pub
git config --global commit.gpgsign true
echo "Signing enabled, add public ssh key to ~/.config/git/allowed_signer"

