#!/bin/bash

set -euo pipefail; shopt -s failglob # safe mode


curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y -q
source "$HOME/.cargo/env"

# linker upgrade
source "$HOME/Documents/dotfiles/setup/rust/ld.mold.sh"

# wasm-pack for WebAssembly compilation
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh -s -- -y

# stable
rustup component add miri rust-analyzer
rustup target add wasm32-unknown-unknown

# nightly + cranelift
rustup toolchain install nightly --component miri
rustup default nightly
rustup target add wasm32-unknown-unknown
rustup component add miri rust-analyzer rustc-codegen-cranelift-preview --toolchain nightly

rsync -avzh "$HOME/Documents/dotfiles/.cargo" "$HOME"
