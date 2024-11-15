#!/bin/bash

# ensure all up to date
sudo apt-get update && sudo apt-get dist-upgrade

# this upgrades distribution version
sudo do-release-upgrade -m desktop

