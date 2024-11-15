sudo apt-get update \
    && sudo apt-get install -y virtualbox-6.0 \
    &&  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
    && sudo install -y minikube-linux-amd64 /usr/local/bin/minikube \
    && ./kubectl.sh
