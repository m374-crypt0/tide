docker_host_socket_path="$(docker context inspect --format '{{ .Endpoints.docker.Host }}' | sed -E 's%^unix://%%')"

docker run --rm -it \
  -e DOCKER_HOST_SOCKET_PATH="$docker_host_socket_path" \
  -v "$docker_host_socket_path":/var/run/docker.sock \
  m374crypt0/tide-lazyvim-prototype:edge bash
