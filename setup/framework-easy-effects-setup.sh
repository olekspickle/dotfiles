#!/bin/bash

MP=$(mktemp -d)
CFG="~/.var/app/com.github.wwmm.easyeffects/config/easyeffects"
mkdir -p "$CFG"
echo "Ensured $CFG exists"

curl -Lo "$TMP"/fwdsp.zip https://github.com/cab404/framework-dsp/archive/refs/heads/master.zip
unzip -d "$TMP" "$TMP"/fwdsp.zip 'framework-dsp-master/config/*/*'
sed -i 's|%CFG%|'"$CFG"'|g' "$TMP"/framework-dsp-master/config/*/*.json
cp -rv "$TMP"/framework-dsp-master/config/* "$CFG"
rm -rf "$TMP"
