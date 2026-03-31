setup_file() {
  bats_require_minimum_version 1.13.0
}

setup() {
  local test_file_dir &&
    test_file_dir="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)/"

  TIDE_ROOT_DIR="${test_file_dir}../../../"

  load "${TIDE_ROOT_DIR}test/test_helper/bats-support/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-assert/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-file/load"

  load "${TIDE_ROOT_DIR}test/test_helper/tide_helpers.sh"
}

teardown() {
  :
}

@test 'install can be made with a curl and controlled environment variables' {
  local tide_install_dir &&
    tide_install_dir="${BATS_TEST_TMPDIR}/.tide/"

  export TIDE_INSTALL_DIR="$tide_install_dir"
  export TIDE_URL="file://${TIDE_ROOT_DIR}/"

  run bats_pipe curl -L "${TIDE_URL}src/install" \| bash

  assert_dir_exists "${tide_install_dir}"
  assert_file_executable "${tide_install_dir}tideup"
  assert_file_executable "${tide_install_dir}tide"
}
