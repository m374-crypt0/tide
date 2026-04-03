# WARN: can only work in latest version of nideovim because of
# DOCKER_SOCKET_PATH variable uses
docker run --rm -it \
  -e DOCKER_HOST_SOCKET_PATH="$DOCKER_SOCKET_PATH" \
  -v "$DOCKER_SOCKET_PATH":/var/run/docker.sock \
  test bash
