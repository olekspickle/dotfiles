#!/bin/bash

KEY=$1
NAME=$2
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $KEY

sudo apt-key export $KEY | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/$NAME.gpg

#sudo apt-key del BE1229CF


