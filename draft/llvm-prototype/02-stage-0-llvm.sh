#!/bin/env bash

base_stamp=edge
this_stamp=$(date -u +%4Y%m%d%H%M%S)

docker build \
  --target build_llvm \
  -f docker/tide-llvm.Dockerfile \
  --build-arg BASE_STAMP=$base_stamp \
  --build-arg USER_UID="$(id -u)" \
  --build-arg USER_GID="$(id -g)" \
  --build-arg USER_NAME="$(id -nu)" \
  -t m374crypt0/tide-llvm-prototype:edge \
  -t m374crypt0/tide-llvm-prototype:"$this_stamp" \
  ./docker
