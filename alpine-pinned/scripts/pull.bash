# shellcheck source=/dev/null
. "${ALPINE_PINNED_ROOT_DIR}/../lib/image-puller.bash"

pull_image "$ALPINE_PINNED_IMAGE_NAME"
