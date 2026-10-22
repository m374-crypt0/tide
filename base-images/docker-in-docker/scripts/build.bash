# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/project-image-builder.bash"

build_project_image "$DOCKER_IN_DOCKER_ROOT_DIR" docker-in-docker
