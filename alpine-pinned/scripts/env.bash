# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/lib/env-generator.bash"

generate_env_file_in "$REGISTRY_ROOT_DIR"
generate_env_file_in "$ALPINE_PINNED_ROOT_DIR"
