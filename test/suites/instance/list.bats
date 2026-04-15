setup_file() {
  bats_require_minimum_version 1.13.0
}

setup() {
  load "${TIDE_ROOT_DIR}test/test_helper/bats-support/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-assert/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-file/load"

  load "${TIDE_ROOT_DIR}test/test_helper/tide_helpers.sh"
  load "${TIDE_ROOT_DIR}test/test_helper/tide_assert.sh"

  # shellcheck disable=SC2329
  instance_list_command() {
    load "${TIDE_ROOT_DIR}src/instance_list_command.sh"
  }
}

teardown() {
  :
}

@test 'Listing instances outside of a project fails' {
  run instance_list_command

  assert_failure
  assert_output 'You are not in a tide project'
}
