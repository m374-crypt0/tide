# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/lib/image-pusher.bash"

push_image "$ALPINE_PINNED_IMAGE_NAME"
