#!/bin/bash

set -e

curl -Sf https://downloads.surfshark.com/linux/debian-install.sh --output surfshark-install.sh

# cat surfshark-install.sh #show script’s content

sh surfshark-install.sh #installs surfshark

rm surfshark-install.sh

sudo apt-get update

sudo apt-get --only-upgrade install surfshark
