#!/bin/bash

set -euo pipefail; shopt -s failglob # safe mode 

RA_PATH="/home/pickle/.local/bin"

mkdir -p $RA_PATH
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ${RA_PATH}/rust-analyzer

chmod +x ${RA_PATH}/rust-analyzer
#echo "export PATH=$PATH:${RA_PATH}" >> ~/.zshrc

