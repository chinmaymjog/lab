#!/bin/bash
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker
docker swarm join --token SWMTKN-1-24jrtkfazeah4y3lxjkzeev25le88op5zql4m9jtzcg79mvkp7-89fv98kkdp0px64fj8h2rcnjb 192.168.6.5:2377