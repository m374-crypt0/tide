IFS=':' read -r _ _ docker_group_id _ <<<"$(getent group docker)"

docker build \
  --build-arg USER_UID="$(id -u)" \
  --build-arg USER_GID="$(id -g)" \
  --build-arg USER_NAME="$(id -nu)" \
  --build-arg DOCKER_HOST_GID="$docker_group_id" \
  -t test .
