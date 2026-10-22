# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/lib/image-puller.bash"

pull_image "$NON_ROOT_USER_IMAGE_NAME"
