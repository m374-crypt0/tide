# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/env-generator.bash"

generate_env_file_in "$DOCKER_REGISTRY_ROOT_DIR"
generate_env_file_in "$NON_ROOT_USER_ROOT_DIR"
generate_env_file_in "$DOCKER_IN_DOCKER_ROOT_DIR"
generate_env_file_in "$LLVM_ROOT_DIR"
generate_env_file_in "$EMACS_ROOT_DIR"
generate_env_file_in "$IDE_ROOT_DIR"
generate_env_file_in "$IDE_WEB_APP_ROOT_DIR"
