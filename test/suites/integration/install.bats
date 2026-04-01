# shellcheck disable=SC2030,SC2031

setup_file() {
  bats_require_minimum_version 1.13.0
}

setup() {
  local test_file_dir &&
    test_file_dir="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)/"

  TIDE_ROOT_DIR="${test_file_dir}../../../"

  export TIDE_INSTALL_DIR="${BATS_TEST_TMPDIR}/.tide/"
  export TIDE_URL="file://${TIDE_ROOT_DIR}/"
  export BASHRC_PATH="${BATS_TEST_TMPDIR}/.bashrc"

  load "${TIDE_ROOT_DIR}test/test_helper/bats-support/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-assert/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-file/load"

  load "${TIDE_ROOT_DIR}test/test_helper/tide_helpers.sh"
  load "${TIDE_ROOT_DIR}test/test_helper/tide_assert.sh"
}

teardown() {
  :
}

@test 'install fails if the user shell is not bash' {
  export SHELL=/bin/sh

  run . "${TIDE_ROOT_DIR}src/install"

  assert_output "bash required"
  assert_failure
}

@test 'install can be made with a curl and controlled environment variables' {
  assert_dir_not_exists "${TIDE_INSTALL_DIR}"
  assert_not_declared_as_path_in "${BASHRC_PATH}" "${TIDE_INSTALL_DIR}"

  run bats_pipe curl -L "${TIDE_URL}src/install" \| bash

  assert_dir_exists "${TIDE_INSTALL_DIR}"

  assert_file_executable "${TIDE_INSTALL_DIR}tideup"
  assert_file_executable "${TIDE_INSTALL_DIR}tide"

  assert_files_equal "${TIDE_INSTALL_DIR}tide" "${TIDE_ROOT_DIR}dist/tide"
  assert_files_equal "${TIDE_INSTALL_DIR}tideup" "${TIDE_ROOT_DIR}src/tideup"
  assert_declared_as_path_in "${BASHRC_PATH}" "${TIDE_INSTALL_DIR}"

  assert_line "tide installed in ${TIDE_INSTALL_DIR} and registered in \$PATH. Start a new shell or login to use."
}
