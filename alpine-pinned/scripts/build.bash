# shellcheck source=/dev/null
. "${ALPINE_PINNED_ROOT_DIR}/../lib/project-image-builder.bash"

build_project_image "$ALPINE_PINNED_ROOT_DIR" alpine-pinned
