#!/bin/bash

version=${1:-"2.5.5"}
echo $version
#sudo apt install libssl-dev liblzo2-dev libpam0g-dev wget

#wget -r https://openvpn.net/index.php/download/community-downloads.html
wget https://swupdate.openvpn.org/community/releases/openvpn-$version.tar.gz

tar -zxf openvpn-$version.tar.gz

cd openvpn-$version

./configure

make 

make install

