#!/bin/bash
if [ "$(docker ps -q -f name=$ENV)" ]; then
    if [[ $ENV = "dev-env" ]]; then
      docker container stop $ENV
      docker container rm $ENV
      docker pull $CI_COMMIT_REF_NAME
      docker run -d -p 8080:80 --name "$ENV" "$DOCKER_REPO/$CI_COMMIT_REF_NAME"
    else
      docker container stop $ENV
      docker container rm $ENV
      docker pull $CI_COMMIT_REF_NAME
      docker run -d -p 80:80 --name "$ENV" "$DOCKER_REPO/$CI_COMMIT_REF_NAME"
    fi
  elif [ "$(docker ps -aq -f status=exited -f name=$ENV)" ]; then
    if [[ $ENV = "dev-env" ]]; then
      docker container rm $ENV
      docker pull $CI_COMMIT_REF_NAME
      docker run -d -p 8080:80 --name "$ENV" "$DOCKER_REPO/$CI_COMMIT_REF_NAME"
    else
      docker container rm $ENV
      docker pull $CI_COMMIT_REF_NAME
      docker run -d -p 80:80 --name "$ENV" "$DOCKER_REPO/$CI_COMMIT_REF_NAME"
    fi
  else
    if [[ $ENV = "dev-env" ]]; then
      docker pull $CI_COMMIT_REF_NAME
      docker run -d -p 8080:80 --name "$ENV" "$DOCKER_REPO/$CI_COMMIT_REF_NAME"
    else
      docker pull $CI_COMMIT_REF_NAME
      docker run -d -p 80:80 --name "$ENV" "$DOCKER_REPO/$CI_COMMIT_REF_NAME"
    fi
fi
