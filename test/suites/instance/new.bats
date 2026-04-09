setup_file() {
  bats_require_minimum_version 1.13.0
}

setup() {
  load "${TIDE_ROOT_DIR}test/test_helper/bats-support/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-assert/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-file/load"

  load "${TIDE_ROOT_DIR}test/test_helper/tide_helpers.sh"
  load "${TIDE_ROOT_DIR}test/test_helper/tide_assert.sh"
}

teardown() {
  :
}

@test 'Cannot create a new instance outside of a project' {
  skip
}
