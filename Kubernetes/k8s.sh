#!/usr/bin/env bash

# Install utils
sudo apt-get update
sudo apt-get install -y curl python-software-properties wget nmap git-core apt-transport-https unzip httpie openssl \
    golang-go jq htop

# Install pip
wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && python3 get-pip.py && rm get-pip.py

# Create serverip
echo "curl -XGET https://www.canihazip.com/s" >> /usr/local/bin/serverip && echo "echo ''" >> /usr/local/bin/serverip && chmod +x /usr/local/bin/serverip

# Create clean-docker
wget https://gist.githubusercontent.com/nithin-jois-we45/962e203d2b0f74d9b18b87d3c4a287e2/raw/cd8b665fd8445f8b084ee6a03f7dbb23484bdfaf/clean-docker
mv clean-docker /usr/local/bin/ && chmod +x /usr/local/bin/clean-docker

# Install docker
echo "Installing Docker"
sudo apt update && wget -qO- https://get.docker.com | sh
echo "Docker installation complete"

# Install node
sudo apt-get update
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install awscli
sudo apt-get install -y awscli

# Install necessary python packages
pip install bandit safety netaddr netifaces enum34 scapy requests PrettyTable urllib3 ruamel.yaml tornado --ignore-installed PyYAML
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
pip uninstall -y urllib3 && pip install urllib3==1.22

# Install K8s
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
apt update && apt install -y kubelet kubeadm kubectl kubernetes-cni

# Install vault
wget https://releases.hashicorp.com/vault/1.0.1/vault_1.0.1_linux_amd64.zip && unzip vault_1.0.1_linux_amd64.zip && mv vault /usr/local/bin && rm vault_1.0.1_linux_amd64.zip

# Install KubeSeal
wget -O /usr/local/bin/kubeseal https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.7.0/kubeseal-linux-amd64 && chmod +x /usr/local/bin/kubeseal

# Clone container-training expires on 31-oct-2019
git clone https://gitlab+deploy-token-77127:SwRRsW7rViQsqM4ovzTY@gitlab.com/we45/container-training.git

# #  TTYD

sudo apt install -y cmake g++ pkg-config git nginx vim-common libwebsockets-dev libjson-c-dev libssl-dev software-properties-common
sudo rm /etc/nginx/sites-enabled/default && wget https://bti-provision.s3-us-west-2.amazonaws.com/default_nginx_site
sudo mv default_nginx_site /etc/nginx/sites-enabled/ && service nginx restart
sudo add-apt-repository -y ppa:tsl0922/ttyd-dev
sudo apt-get update
sudo apt-get install -y ttyd
# sudo ttyd -p 80 bash &
