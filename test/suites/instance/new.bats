setup_file() {
  bats_require_minimum_version 1.13.0
}

setup() {
  load "${TIDE_ROOT_DIR}test/test_helper/bats-support/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-assert/load"
  load "${TIDE_ROOT_DIR}test/test_helper/bats-file/load"

  load "${TIDE_ROOT_DIR}test/test_helper/tide_helpers.sh"
  load "${TIDE_ROOT_DIR}test/test_helper/tide_assert.sh"

  tide_instance_new() {
    local template_name && template_name="$1"

    exec bash -c "${TIDE_ROOT_DIR}dist/tide instance new --template=${template_name}"
  }
}

teardown() {
  :
}

@test 'Cannot create a new instance outside of a project' {
  run tide_instance_new base

  assert_failure
  assert_line 'You are not in a tide project'
}
