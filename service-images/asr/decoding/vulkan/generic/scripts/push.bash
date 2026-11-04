# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-pusher.bash"
. "${TIDE_ROOT_DIR}/.scripts/docker-login.bash"

docker_login &&
  push_image "$ADVG_IMAGE_NAME"
