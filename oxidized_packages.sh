#!/bin/bash

# find
sudo apt install fd-find
ln -s $(which fdfind) ~/.local/bin/fd

# grep
cargo install ripgrep
