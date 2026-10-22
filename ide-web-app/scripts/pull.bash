# shellcheck source=/dev/null
. "${IDE_WEB_APP_ROOT_DIR}/../.scripts/image-puller.bash"

pull_image "$IDE_WEB_APP_IMAGE_NAME"
