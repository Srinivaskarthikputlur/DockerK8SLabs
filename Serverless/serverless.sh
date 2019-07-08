#!/usr/bin/env bash

# Install utils
sudo apt-get update
sudo apt-get install -y curl python-software-properties wget nmap git-core apt-transport-https unzip httpie openssl \
    golang-go jq htop

# Install pip
wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && python3 get-pip.py && rm get-pip.py

# Create serverip
echo "curl -XGET https://www.canihazip.com/s" >> /usr/local/bin/serverip && echo "echo ''" >> /usr/local/bin/serverip && chmod +x /usr/local/bin/serverip

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

# Clone repositories
git clone https://github.com/we45/DVFaaS-Damn-Vulnerable-Functions-as-a-Service.git ~/DVFaaS-Damn-Vulnerable-Functions-as-a-Service
git clone https://github.com/we45/Cut-The-Funds-NodeJS.git ~/Cut-The-Funds-NodeJS
git clone https://github.com/we45/NodeJsScan.git ~/NodeJsScan
git clone https://github.com/we45/serverless-training-apps.git ~/serverless-training-apps

# Create pipenv for DvFaaS
pip install pipenv && pip uninstall -y urllib3 && pip install urllib3==1.22
cd /root/DVFaaS-Damn-Vulnerable-Functions-as-a-Service && pipenv --python /usr/bin/python3 install boto3 && cd ~/


# Clone container-training expires on 31-oct-2019
git clone https://gitlab+deploy-token-77127:SwRRsW7rViQsqM4ovzTY@gitlab.com/we45/container-training.git

