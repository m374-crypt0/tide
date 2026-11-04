# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-puller.bash"
. "${TIDE_ROOT_DIR}/.scripts/docker-login.bash"

docker_login &&
  pull_image "$LOCAL_DOCKER_REGISTRY_IMAGE_NAME"
