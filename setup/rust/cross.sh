#!/bin/bash

set -e

sudo apt install -y \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    libc6-dev-armhf-cross \
    binutils-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    libc6-dev-arm64-cross \
    binutils-aarch64-linux-gnu \
    qemu-user quemu-user-static binfmt-support

cargo install cross --locked

cargo_config="$HOME/.cargo/config.toml"
mkdir -p "$(dirname "$cargo_config")"

cat <<EOF >> "$cargo_config"
[target.armv7-unknown-linux-gnueabihf]
linker = "arm-linux-gnueabihf-gcc"

[target.aarch64-unknown-linux-gnu]
linker = "aarch64-linux-gnu-gcc"
EOF

# enable user mode qemu emulators and register it persistenlty via binfmt_misc
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
# Install and register binfmt handlers for many architectures (mostly for aarch64, armhf, ppc64le, s390x, riscv64)
docker run --privileged --rm tonistiigi/binfmt --install all

echo "ARM cross-compilation setup complete!"
