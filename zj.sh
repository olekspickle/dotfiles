#! /bin/bash

set -euo pipefail; shopt -s failglob # safe mode

cargo install zellij

echo "Migrating zj configs..."
mkdir ~/.config/zellij
mkdir ~/.config/zellij/layouts
cp zj-config.kdl ~/.config/zellij/config.kdl
cp zj-layout-config.kdl ~/.config/zellij/layouts/config.kdl

# adding KDL syntax for nvim
cd ~/.config/nvim/site/pack/packer/start && git clonee https://github.com/imsnif/kdl.vim
