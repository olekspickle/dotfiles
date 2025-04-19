#!/bin/bash

set -e

# installs mold linker and adds its config to global cargo config
sudo apt-get update -y
sudo apt-get install -y mold clang

# Create cargo config file if it doesn't exist
cargo_config_file=~/.cargo/config
mkdir -p $(dirname "$cargo_config_file")

# Write mold configuration to cargo config
cat <<EOF >> "$cargo_config_file"
[target.x86_64-unknown-linux-gnu]
linker = "clang"
rustflags = ["-C", "link-arg=-fuse-ld=$(which mold)"]
EOF

# Print a confirmation message
echo "Mold configuration added to $cargo_config_file"

