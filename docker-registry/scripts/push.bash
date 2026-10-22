# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/lib/image-pusher.bash"

push_image "$DOCKER_REGISTRY_IMAGE_NAME"
