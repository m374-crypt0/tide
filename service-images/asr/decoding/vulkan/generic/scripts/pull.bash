# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-puller.bash"
. "${TIDE_ROOT_DIR}/.scripts/docker-login.bash"

docker_login &&
  pull_image "$ADVG_IMAGE_NAME"
