# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-puller.bash"

pull_image "$EMACS_IMAGE_NAME"
