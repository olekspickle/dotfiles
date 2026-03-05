#!/bin/bash

set -e

# installs mold linker and adds its config to global cargo config
sudo apt-get update -y
sudo apt-get install -y mold clang

