# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/project-image-builder.bash"

build_project_image "$LLVM_ROOT_DIR" llvm
