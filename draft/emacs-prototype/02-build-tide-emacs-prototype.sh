#!/bin/env bash

IFS=':' read -r _ _ docker_group_id _ <<<"$(getent group docker)"

base_stamp=edge
this_stamp=$(date -u +%4Y%m%d%H%M%S)

docker build \
  -f docker/tide-emacs-prototype.Dockerfile \
  --build-arg BASE_STAMP=$base_stamp \
  --build-arg USER_UID="$(id -u)" \
  --build-arg USER_GID="$(id -g)" \
  --build-arg USER_NAME="$(id -nu)" \
  --build-arg DOCKER_HOST_GID="$docker_group_id" \
  -t m374crypt0/tide-emacs-prototype:edge \
  -t m374crypt0/tide-emacs-prototype:"$this_stamp" \
  ./docker
