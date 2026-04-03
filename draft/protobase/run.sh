docker run --rm -it \
  -e DOCKER_HOST_SOCKET_PATH="$DOCKER_SOCKET_PATH" \
  -v "$DOCKER_SOCKET_PATH":/var/run/docker.sock \
  test bash
