#!/bin/bash
apt-get -y update
touch kub_install.log
echo $HOME >> kub_install.log
echo $USER >> kub_install.log
kubeadm init --pod-network-cidr=${pod_subnet} --token ${token} >> kub_install.log
sleep 60
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml >> kub_install.log
