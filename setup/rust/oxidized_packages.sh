#!/bin/bash

# find
sudo apt install fd-find
ln -s $(which fdfind) ~/.local/bin/fd

# rust cat
cargo install --locked bat

cargo install cargo-binstall
cargo binstall ripgrep flamegraph zellij \
    cargo-deny cargo-readme cargo-machete cargo-bloat cargo-tree

# fetch zellij plugins
zj_plugin_dir="~/.config/zellij/plugins"
curl -sL https://github.com/dj95/zjstatus/releases/download/v0.17.0/zjstatus.wasm \
    -o "$zj_plugins_dir"/zjstatus.wasm
curl -sL https://github.com/imsnif/weather-pal/releases/download/0.1.0/weather-pal.wasm \
    -o "$zj_plugins_dir"/zj_weather.wasm
curl -sL https://github.com/karimould/zellij-forgot/releases/download/0.4.0/zellij_forgot.wasm \
    -o "$zj_plugins_dir"/zj_forgot.wasm


# enable perf to be used by unprivileged for flamegraph
# echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid

rustup toolchain install nightly --component miri

# shell history with sqlite
bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)
atuin import auto
