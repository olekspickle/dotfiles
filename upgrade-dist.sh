#!/bin/bash

# ensure all up to date
sudo apt update && sudo apt dist-upgrade

# this upgrades distribution version
sudo do-release-upgrade -m desktop

