docker_login(){
  docker login \
	-u "${LOCAL_DOCKER_REGISTRY_USER_NAME}" \
	-p "${LOCAL_DOCKER_REGISTRY_USER_PASSWORD}" \
	"http://${LOCAL_DOCKER_REGISTRY_HOST}:${LOCAL_DOCKER_REGISTRY_PORT}" \
	2>/dev/null ||
		echo 'warning, local docker registry cannot be reached.' >&2
}
