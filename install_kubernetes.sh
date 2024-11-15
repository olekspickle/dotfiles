sudo apt-get update \
    && sudo apt-get install virtualbox-6.0 \
    &&  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
    && sudo install minikube-linux-amd64 /usr/local/bin/minikube \
    && ./install_kubectl.sh
