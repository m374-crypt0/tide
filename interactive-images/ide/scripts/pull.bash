# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-puller.bash"
. "${TIDE_ROOT_DIR}/.scripts/docker-login.bash"

docker_login &&
  pull_image "$IDE_IMAGE_NAME"
