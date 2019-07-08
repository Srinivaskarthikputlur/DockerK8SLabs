#!/usr/bin/env bash

# Install utils
sudo apt update
sudo apt install -y curl python-software-properties wget nmap git-core apt-transport-https unzip httpie openssl \
    golang-go jq htop

# Install pip
wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && python3 get-pip.py && rm get-pip.py

# Create serverip
echo "curl -XGET https://www.canihazip.com/s" >> /usr/local/bin/serverip && echo "echo ''" >> /usr/local/bin/serverip && chmod +x /usr/local/bin/serverip

# Create clean-docker
wget https://gist.githubusercontent.com/nithin-jois-we45/962e203d2b0f74d9b18b87d3c4a287e2/raw/cd8b665fd8445f8b084ee6a03f7dbb23484bdfaf/clean-docker
mv clean-docker /usr/local/bin/ && chmod +x /usr/local/bin/clean-docker

# Create secret file
echo "This is a secret" >> /root/secret.txt

# Install docker
echo "Installing Docker"
sudo apt update && wget -qO- https://get.docker.com | sh
echo "Docker installation complete"

# Install Dive
wget https://github.com/wagoodman/dive/releases/download/v0.6.0/dive_0.6.0_linux_amd64.deb
sudo apt install ./dive_0.6.0_linux_amd64.deb && rm dive_0.6.0_linux_amd64.deb

# Install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install necessary python packages
pip install bandit safety netaddr netifaces enum34 scapy requests PrettyTable urllib3 ruamel.yaml tornado --ignore-installed PyYAML
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
pip uninstall -y urllib3 && pip install urllib3==1.22

# Create we45 user and add to Docker group
sudo useradd -m -s /bin/bash "we45"
bash -c "usermod -aG docker we45"

# Clone container-training expires on 31-oct-2019
git clone https://gitlab+deploy-token-77127:SwRRsW7rViQsqM4ovzTY@gitlab.com/we45/container-training.git

# Pull ubuntu and alpine images
docker pull ubuntu:latest && docker pull alpine:latest


# #  TTYD

sudo apt install -y cmake g++ pkg-config git nginx vim-common libwebsockets-dev libjson-c-dev libssl-dev software-properties-common
sudo rm /etc/nginx/sites-enabled/default && wget https://bti-provision.s3-us-west-2.amazonaws.com/default_nginx_site
sudo mv default_nginx_site /etc/nginx/sites-enabled/ && service nginx restart
sudo add-apt-repository -y ppa:tsl0922/ttyd-dev
sudo apt-get update
sudo apt-get install -y ttyd
# sudo ttyd -p 80 bash &
