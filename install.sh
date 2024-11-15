#! /bin/bash 


echo "Installing basic tools..."
sudo apt-get install -y python3 pkg-config build-essential curl cmake 

echo "Installing image related tools..."
./install_images_related.sh 

echo "Installing postgress..."
./install_psql.sh 

echo "Installing fonts..."
./install_fonts.sh 

echo "Installing node..."
./install_node.sh 

echo "Installing rust..."
./install_rust.sh 

echo "Installing snap packages..."
./snap.sh
