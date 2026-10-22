# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/lib/image-puller.bash"

pull_image "$DOCKER_IN_DOCKER_IMAGE_NAME"
