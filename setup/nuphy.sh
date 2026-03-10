#!/bin/bash

nuphy_rules_path="/etc/udev/rules.d/50-nuphy.rules"

# Copy the following to the file
# NuPhy keyboards

cat EOF< '
# NuPhy keyboards
SUBSYSTEM=="usb", ATTR{idVendor}=="19f5", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="19f5", MODE="0666", GROUP="plugdev"'
EOF > "$nuphy_rules_path"

sudo udevadm control --reload-rules
sudo udevadm trigger
sudo usermod -a -G plugdev $USER

newgrp plugdev

