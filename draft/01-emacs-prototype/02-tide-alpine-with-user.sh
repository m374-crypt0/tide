#!/bin/env bash

base_stamp=edge
this_stamp=$(date -u +%4Y%m%d%H%M%S)

docker build \
  -f contexts/tide-alpine-with-user/Dockerfile \
  --build-arg BASE_STAMP=$base_stamp \
  --build-arg USER_UID="$(id -u)" \
  --build-arg USER_GID="$(id -g)" \
  --build-arg USER_NAME="$(id -nu)" \
  -t m374crypt0/tide-alpine-with-user:edge \
  -t m374crypt0/tide-alpine-with-user:"$this_stamp" \
  ./contexts/tide-alpine-with-user
