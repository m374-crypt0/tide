# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-puller.bash"

pull_image "$LLVM_IMAGE_NAME"
