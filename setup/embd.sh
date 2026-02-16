#!/bin/bash

# embedded debug flash/tools
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/probe-rs/probe-rs/releases/latest/download/probe-rs-tools-installer.sh | sh

# longan-nano risc-v target
rustup target add riscv32imac-unknown-none-elf
