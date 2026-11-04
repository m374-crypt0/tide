# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/project-image-builder.bash"
. "${TIDE_ROOT_DIR}/.scripts/docker-login.bash"

docker_login &&
  build_project_image "$NON_ROOT_USER_ROOT_DIR" non-root-user
