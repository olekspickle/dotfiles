#!/bin/bash

set -euo pipefail; shopt -s failglob # safe mode

PREFIX="$HOME/Documents/dotfiles/setup/rust"


curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y -q
source "$HOME/.cargo/env"

# linker upgrade
source "$PREFIX/ld.mold.sh"

# wasm-pack for WebAssembly compilation
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh -s -- -y

source "$PREFIX/toolchains.sh"

rsync -avzh "$HOME/Documents/dotfiles/.cargo" "$HOME"
