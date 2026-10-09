# shellcheck source=/dev/null
. "${ALPINE_PINNED_ROOT_DIR}/../lib/image-pusher.bash"

push_image "$ALPINE_PINNED_IMAGE_NAME"
