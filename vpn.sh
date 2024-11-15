#!/bin/bash

# client
sudo apt install openvpn
# OLD
#wget -r https://openvpn.net/index.php/download/community-downloads.html
#wget https://swupdate.openvpn.org/community/releases/openvpn-$version.tar.gz
#tar -zxf openvpn-$version.tar.gz
#cd openvpn-$version
#./configure
#make 
#make install


# handle --server flag

# for servers
version=${1:-"2.5.5"}
echo $version

sudo apt install libssl-dev liblzo2-dev libpam0g-dev wget

# create a new directory on the OpenVPN Server
mkdir ~/easy-rsa
# create a symlink from the easyrsa script that the package installed into the ~/easy-rsa directory
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
# ensure the directory’s owner is your non-root sudo user and restrict access to that user
sudo chown $USER ~/easy-rsa
chmod 700 ~/easy-rsa

vars=`
set_var EASYRSA_ALGO "ec"
set_var EASYRSA_DIGEST "sha512"
`

echo $vars > ~/easy-rsa/vars
