#/bin/bash

fix=`
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
`

sudo echo $fix >> /etc/default/locale
echo $fix >> ~/.bashrc

sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# if this did not do it, do this and log out
#sudo dpkg-reconfigure locales
