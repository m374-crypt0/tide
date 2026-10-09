# shellcheck source=/dev/null
. "${DOCKER_IN_DOCKER_ROOT_DIR}/../lib/project-image-builder.bash"

build_project_image "$DOCKER_IN_DOCKER_ROOT_DIR" docker-in-docker
