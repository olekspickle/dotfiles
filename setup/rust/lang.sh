#!/bin/bash

set -euo pipefail; shopt -s failglob # safe mode


curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y -q
source "/home/pickle/.cargo/env"

# linker upgrade
source "/home/pickle/Documents/dotfiles/setup/rust/ld.mold.sh"

# wasm-pack for WebAssembly compilation
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh -s -- -y

# rust analyzer
rustup component add rust-analyzer
# install wasm target
rustup target add wasm32-unknown-unknown
