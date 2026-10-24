# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-pusher.bash"

push_image "$STRIX_HALO_IMAGE_NAME"

# TODO: ensure all push.bash are correctly refactored
