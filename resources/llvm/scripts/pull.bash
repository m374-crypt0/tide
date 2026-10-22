# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/lib/image-puller.bash"

pull_image "$LLVM_IMAGE_NAME"
