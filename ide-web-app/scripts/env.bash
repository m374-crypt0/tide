# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/lib/env-generator.bash"

generate_env_file_in "$REGISTRY_ROOT_DIR"
generate_env_file_in "$NON_ROOT_USER_ROOT_DIR"
generate_env_file_in "$IDE_ROOT_DIR"
generate_env_file_in "$IDE_WEB_APP_ROOT_DIR"
