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
}

teardown() {
  :
}

@test 'install can be made with a curl and controlled environment variables' {
  local url && url="file://${TIDE_ROOT_DIR}src/install"
  local install_dir && install_dir="${BATS_TEST_TMPDIR}/install/"

  assert_dir_exists "${install_dir}"
  assert_file_exists "${install_dir}tideup"
  assert_file_exists "${install_dir}tide"
}
