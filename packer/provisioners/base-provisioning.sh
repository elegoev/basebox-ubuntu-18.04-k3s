#!/bin/bash

application_file_path="/vagrant/installed-application.md"

# Ubuntu provisioning file
sudo apt update

# install k3s without agent
sudo curl -sfL https://get.k3s.io | sh -

# add aliases to bash shell
echo "alias kubectl='k3s kubectl'" >> ~/.bashrc

# install helm
sudo snap install helm --classic

# set version
DOCKER_VERSION=$(sudo docker version --format '{{.Server.Version}}')
HELM_VERSION=$(sudo snap info helm | grep installed | awk  '{print $2}')
K3S_VERSION=$(sudo k3s --version | grep k3s | awk  '{print $3}' | tr --delete v)
echo "# Installed application "  > $application_file_path
echo "***                     " >> $application_file_path
echo "> Docker: $DOCKER_VERSION" >> $application_file_path
echo "> Helm: $HELM_VERSION" >> $application_file_path
echo "> k3s: $K3S_VERSION" >> $application_file_path


