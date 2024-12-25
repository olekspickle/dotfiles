#!/bin/bash

# install solana-cli
echo Installing solana...
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
export PATH="/home/pickle/.local/share/solana/install/active_release/bin:$PATH"
agave-install update

# install amchor framework
cargo install --git https://github.com/coral-xyz/anchor avm --force
avm install latest
avm use latest

solana --version
avm --version
anchor --version

