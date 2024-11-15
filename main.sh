#! /bin/bash 

echo "Installing basic tools..."
sudo apt install -y python3 pkg-config build-essential curl cmake 

echo "Installing image related tools..."
./images_related.sh 

echo "Installing postgress..."
./psql.sh 

echo "Installing fonts..."
./fonts.sh 

echo "Installing node..."
./node.sh 

echo "Installing rust..."
./rust.sh 

echo "Installing snap packages..."
./snap.sh

# ./noise_cancellation.sh
