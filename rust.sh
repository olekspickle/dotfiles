#!/bin/bash

set -euo pipefail; shopt -s failglob # safe mode 


curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
source $HOME/.cargo/env

./lld.sh

