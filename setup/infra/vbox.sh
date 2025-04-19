#!/bin/bash

set -e

v=$(curl -sS https://download.virtualbox.org/virtualbox/LATEST.TXT)
echo Version: $v
codename=$(lsb_release -c | awk '{print $2}')

url=$(curl -sS https://download.virtualbox.org/virtualbox/$v | rg 'Ubuntu' | rg $codename | awk '{split($0, arr, "[\"\"]"); print arr[2]}')
ref="https://download.virtualbox.org/virtualbox/$v/$url"

echo Downloading virtualbox deb package for $codename...
echo $ref

#curl -sS $ref -o virtual.deb

#sudo apt install ./virtual.deb

#wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

#rm virtual.deb
