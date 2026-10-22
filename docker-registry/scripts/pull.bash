# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-puller.bash"

pull_image "$DOCKER_REGISTRY_IMAGE_NAME"
