#!/bin/bash
# Update the apt package index
sudo apt-get -y update
# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Add docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Update the apt package index
sudo apt-get -y update
# Install Docker
sudo apt-get install -y docker-ce
# Add manage user to docker group
sudo usermod -aG docker $USER
# Enable docker service at boot
sudo systemctl enable docker
# Installing kubeadm, kubectl, kubelet
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get -y update
sudo apt-get install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet
# Disable SELINUX
sudo sed -i 's/^\(SELINUX=\)enforcing/\1disabled/' /etc/selinux/config
# Turn off swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
