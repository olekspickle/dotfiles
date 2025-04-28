#!/bin/bash

# Nomad uses CNI plugins to configure network namespaces when using the bridge network mode. All Linux Nomad client nodes using network namespaces must have CNI plugins installed.
# Install the CNI reference plugins
curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v1.0.0.tgz && \
  sudo mkdir -p /opt/cni/bin && \
  sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz

# Ensure your Linux operating system distribution has been configured to allow container traffic through the bridge network to be routed via iptables.
# These tunables can be set as follows
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-arptables
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-ip6tables
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables

