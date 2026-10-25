# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-pusher.bash"

push_image "$NON_ROOT_USER_IMAGE_NAME"
