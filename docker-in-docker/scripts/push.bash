# shellcheck source=/dev/null
. "${DOCKER_IN_DOCKER_ROOT_DIR}/../lib/image-pusher.bash"

push_image "$DOCKER_IN_DOCKER_IMAGE_NAME"
