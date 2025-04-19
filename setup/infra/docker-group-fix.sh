#! /bin/bash

set +e

sudo newgrp docker
sudo groupadd docker

sudo usermod -aG docker $USER

sudo chown root:docker /var/run/docker.sock
