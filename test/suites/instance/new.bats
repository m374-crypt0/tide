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
  tide_instance_new() {
    local template_name && template_name="$1"

    exec bash -c "${TIDE_ROOT_DIR}dist/tide instance new --template=${template_name}"
  }

  # shellcheck disable=SC2329
  tide_init() {
    exec bash -c "${TIDE_ROOT_DIR}dist/tide init"
  }
}

teardown() {
  :
}

@test 'Cannot create a new instance outside of a project' {
  run tide_instance_new lazyvim

  assert_failure
  assert_line 'You are not in a tide project'
}

@test 'Cannot create an instance from unexisting template' {
  cd "$BATS_TEST_TMPDIR"
  run tide_init

  run tide_instance_new unexisting_problem

  assert_failure
  assert_line 'the template unexisting_problem does not exist'
}

@test 'Can create the first instance of the lazyvim template' {
  skip
  cd "$BATS_TEST_TMPDIR"
  run tide_init

  run tide_instance_new lazyvim

  assert_success
  assert_dir_exists "${BATS_TEST_TMPDIR}/.tide/instances/lazyvim/0"
  assert_file_exists "${BATS_TEST_TMPDIR}/.tide/instances/lazyvim/0/config.build.ini"
  assert_file_exists "${BATS_TEST_TMPDIR}/.tide/instances/lazyvim/0/config.run.ini"
}

@test 'Can create the several instances of the lazyvim template' {
  skip
}

@test 'After instance creation, display instance info' {
  skip
}
