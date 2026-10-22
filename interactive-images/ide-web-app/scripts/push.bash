# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-pusher.bash"

push_image "$IDE_WEB_APP_IMAGE_NAME"
