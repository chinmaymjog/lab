#!/bin/bash
apt-get -y update
touch kub_install.log
echo $HOME >> kub_install.log
echo $USER >> kub_install.log
sleep 60
kubeadm join ${master_ip}:6443 --token ${token} --discovery-token-unsafe-skip-ca-verification >> kub_install.log