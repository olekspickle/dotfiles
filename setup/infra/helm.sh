#!/bin/bash

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh

chmod 700 get_helm.sh
sh get_helm.sh
rm get_helm.sh
