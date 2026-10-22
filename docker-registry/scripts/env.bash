# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/lib/env-generator.bash"

( generate_env_file_in "$DOCKER_REGISTRY_ROOT_DIR" )
