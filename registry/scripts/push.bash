# shellcheck source=/dev/null
. "${REGISTRY_ROOT_DIR}/../lib/image-pusher.bash"

push_image "$REGISTRY_IMAGE_NAME"
