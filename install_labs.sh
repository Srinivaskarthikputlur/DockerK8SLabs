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

# Create secret file
echo "This is a secret" >> /root/secret.txt

# Install docker
echo "Installing Docker"
sudo apt-get update && wget -qO- https://get.docker.com | sh
echo "Docker installation complete"

# Install lynis
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C80E383C3DE9F082E01391A0366C67DE91CA5D5F
sudo add-apt-repository "deb [arch=amd64] https://packages.cisofy.com/community/lynis/deb/ xenial main"
sudo apt-get update -y
sudo apt-get install -y lynis

# Install node
sudo apt-get update
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install awscli
sudo apt-get install -y awscli

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

# Install docker-slim
wget https://downloads.dockerslim.com/releases/1.25.0/dist_linux.tar.gz && tar -xvzf dist_linux.tar.gz && rm dist_linux.tar.gz && mv dist_linux/* /usr/local/bin/ && rm -rf dist_linux/

# Clone repositories
git clone https://github.com/we45/DVFaaS-Damn-Vulnerable-Functions-as-a-Service.git ~/DVFaaS-Damn-Vulnerable-Functions-as-a-Service
git clone https://github.com/we45/Cut-The-Funds-NodeJS.git ~/Cut-The-Funds-NodeJS
git clone https://github.com/we45/NodeJsScan.git ~/NodeJsScan
git clone https://github.com/we45/serverless-training-apps.git ~/serverless-training-apps

# Create pipenv for DvFaaS
pip install pipenv
cd /root/DVFaaS-Damn-Vulnerable-Functions-as-a-Service && pipenv --python /usr/bin/python3 install boto3 && cd ~/

# Create we45 user and add to Docker group
sudo useradd -m -s /bin/bash "we45"
bash -c "usermod -aG docker we45"

# Install K8s
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
apt update && apt install -y kubelet kubeadm kubectl kubernetes-cni

# Install vault
wget https://releases.hashicorp.com/vault/1.0.1/vault_1.0.1_linux_amd64.zip && unzip vault_1.0.1_linux_amd64.zip && mv vault /usr/local/bin && rm vault_1.0.1_linux_amd64.zip

# Install KubeSeal
wget -O /usr/local/bin/kubeseal https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.7.0/kubeseal-linux-amd64 && chmod +x /usr/local/bin/kubeseal

# Allow ssh with password
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service ssh restart
service sshd restart

# Clone container-training (Token expires on 27 July 2019)
git clone https://gitlab+deploy-token-74859:if-CbsryE3YMn3XUjXXF@gitlab.com/we45/container-training.git
