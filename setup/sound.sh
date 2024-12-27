#!/bin/bash

# from https://kx.studio/Repositories
# install kx studio repositories
sudo apt-get update
sudo apt-get install apt-transport-https gpgv wget
wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_11.1.0_all.deb
sudo dpkg -i kxstudio-repos_11.1.0_all.deb
rm kxstudio-repos_11.1.0_all.deb

