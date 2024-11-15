#!/bin/bash

set -euo pipefail; shopt -s failglob # safe mode 

mkdir -p ~/.local/bin
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
echo "export PATH=$PATH:/home/pickle/.local/bin" >> ~/.zshrc

