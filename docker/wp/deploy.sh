#!/bin/bash
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
docker rm -f  dev-site
docker run -d -p 80:80 -p 443:443 --name dev-site -e WORDPRESS_DB_HOST=$DB_HOST:$DB_PORT -e WORDPRESS_DB_NAME=$DEV_DB -e WORDPRESS_DB_USER=$DEV_DB_USER -e WORDPRESS_DB_PASSWORD=$DEV_DB_PASSWORD $DOCKER_REPOSITORY:latest