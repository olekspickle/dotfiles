#!/bin/bash

# stable
rustup component add miri rust-analyzer
# WASM
rustup target add wasm32-unknown-unknown
# ARM
rustup target add armv7a-none-eabi aarch64-unknown-linux-gnu
# OTHER rarely used targets
# rustup target add thumbv6m-none-eabi thumbv7em-none-eabihf

# Windows + ensure linux
rustup target add x86_64-pc-windows-gnu x86_64-unknown-linux-gnu

# nightly + cranelift
rustup toolchain install nightly
rustup default nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
rustup component add rust-src miri rust-analyzer rustc-codegen-cranelift-preview --toolchain nightly

# cranelift setup
cargo_config="$HOME/.cargo/config"
# Create cargo config file if it doesn't exist
mkdir -p $(dirname "$cargo_config")

sudo apt install -y mold

# Adds this section to cargo config
cat <<EOF >> "$cargo_config"
[unstable]
codegen-backend = true
[profile.dev]
codegen-backend = "cranelift"
# Consider compiling deps with llvm for runtime perf and working `#[should_panic]`
# If you don't have any tests that `#[should_panic]`, comment this out for *massive* speedups
# For me, it makes a 16 minute build take 6 minutes.
[profile.dev.package."*"]
codegen-backend = "llvm"
[profile.release] # Disable cranelift for release profile
codegen-backend = "llvm"
[profile.web] # cranelift cannot build wasm32-unknown-unknown out of the box
codegen-backend = "llvm"

[target.x86_64-unknown-linux-gnu]
linker = "clang"
rustflags = [
    # Nightly
    "-Clink-arg=-fuse-ld=mold", # mold linker
    "-Zshare-generics=y",
    "-Zthreads=0",
]
rustdocflags = [
    # Nightly
    "-Clink-arg=-fuse-ld=mold", # mold linker
    "-Zshare-generics=y",
    "-Zthreads=0",
]
EOF

echo "Enjoy faster build times!"


