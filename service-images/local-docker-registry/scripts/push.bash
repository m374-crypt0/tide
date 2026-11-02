# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-pusher.bash"

push_image "$LOCAL_DOCKER_REGISTRY_IMAGE_NAME"
