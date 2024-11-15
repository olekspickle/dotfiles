#!/bin/bash

set -e

# this inststalls mold linker and adds its config to global cargo config

toml_config='
[target.x86_64-unknown-linux-gnu]
linker = "/usr/bin/clang"
rustflags = ["-C", "link-arg=--ld-path=/usr/bin/mold"]
'

git clone https://github.com/rui314/mold.git
cd mold
git checkout v1.2.1
make -j$(nproc) CXX=clang++
sudo make install

rm -rf mold
