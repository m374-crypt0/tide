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

  export TIDE_INSTALL_DIR="${BATS_TEST_TMPDIR}/.tide/"

  export TIDE_URL="file://${TIDE_ROOT_DIR}/"
  export BASHRC_PATH="${BATS_TEST_TMPDIR}/.bashrc"
  curl -L "${TIDE_URL}src/install" | bash
}

teardown() {
  :
}

@test 'tideup installs tide' {
  assert_file_not_exists "${TIDE_INSTALL_DIR}tide"

  run "${TIDE_INSTALL_DIR}tideup"

  assert_file_executable "${TIDE_INSTALL_DIR}dist/tide"
  assert_files_equal "${TIDE_INSTALL_DIR}dist/tide" "${TIDE_ROOT_DIR}dist/tide"
}
