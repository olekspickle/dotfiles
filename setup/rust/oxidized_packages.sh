#!/bin/bash

# find
sudo apt install -y fd-find
ln -s $(which fdfind) ~/.local/bin/fd

# rust cat
cargo install -q --locked bat

cargo install -q cargo-binstall
cargo binstall -y dysk ripgrep flamegraph zellij \
    cargo-deny cargo-readme cargo-machete cargo-bloat cargo-tree \
    cargo-audit

# enable perf to be used by unprivileged for flamegraph
# echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid


# shell history with sqlite
bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)

# starship prompt
curl -sS https://starship.rs/install.sh | sh

atuin import auto
