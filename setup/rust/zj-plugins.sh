#!/bin/bash

# fetch zellij plugins
zj_plugins_dir="~/.config/zellij/plugins"
curl -L https://github.com/dj95/zjstatus/releases/download/v0.17.0/zjstatus.wasm \
    -o zjstatus.wasm
mv zjstatus.wasm "$zj_plugins_dir/zjstatus.wasm"
curl -L https://github.com/imsnif/weather-pal/releases/download/0.1.0/weather-pal.wasm \
    -o zj_weather.wasm
mv zj_weather.wasm "$zj_plugins_dir/zj_weather.wasm"

