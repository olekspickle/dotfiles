#!/bin/bash

# fetch zellij plugins
zj_plugin_dir="~/.config/zellij/plugins"
curl -sL https://github.com/dj95/zjstatus/releases/download/v0.17.0/zjstatus.wasm \
    -o "$zj_plugins_dir"/zjstatus.wasm
curl -sL https://github.com/imsnif/weather-pal/releases/download/0.1.0/weather-pal.wasm \
    -o "$zj_plugins_dir"/zj_weather.wasm
curl -sL https://github.com/karimould/zellij-forgot/releases/download/0.4.0/zellij_forgot.wasm \
    -o "$zj_plugins_dir"/zj_forgot.wasm

