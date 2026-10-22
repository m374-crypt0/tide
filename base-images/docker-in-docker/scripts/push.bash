# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-pusher.bash"

push_image "$DOCKER_IN_DOCKER_IMAGE_NAME"
