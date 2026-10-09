# shellcheck source=/dev/null
. "${REGISTRY_ROOT_DIR}/../lib/image-puller.bash"

pull_image "$REGISTRY_IMAGE_NAME"
