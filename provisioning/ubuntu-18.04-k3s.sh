#!/bin/bash

# Ubuntu provisioning file
sudo apt update

# install k3s without agent
sudo curl -sfL https://get.k3s.io | sh -

# add aliases to bash shell
echo "alias kubectl='k3s kubectl'" >> ~/.bashrc

# create date string
DATE=`date +%Y%m%d%H%M`

# store k3s version
K3S_VERSION=$(sudo k3s --version | awk  '{print $3}' | tr --delete v)
echo "k3s-$K3S_VERSION" > /vagrant/version
