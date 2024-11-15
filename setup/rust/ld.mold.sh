#!/bin/bash

set -e

# installs mold linker and adds its config to global cargo config

git clone https://github.com/rui314/mold.git
mkdir mold/build && cd mold/build
git checkout v1.5.1
../install-build-deps.sh
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ ..
cmake --build . -j $(nproc)
sudo cmake --install .

cargo_mold='
[target.x86_64-unknown-linux-gnu]
rustflags = ["-C", "link-arg=-fuse-ld=$(which mold)"]
'

cat $cargo_mold >> ~/.cargo/config

cd ../../
rm -rf mold
