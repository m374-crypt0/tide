# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/env-generator.bash"

generate_env_file_in "$LOCAL_DOCKER_REGISTRY_ROOT_DIR"
generate_env_file_in "$NON_ROOT_USER_ROOT_DIR"
generate_env_file_in "$LLVM_ROOT_DIR"
generate_env_file_in "$ADVG_ROOT_DIR"
