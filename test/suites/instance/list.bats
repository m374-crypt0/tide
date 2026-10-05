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
  tide_instance_list() {
    exec bash -c "${TIDE_ROOT_DIR}dist/tide instance list"
  }

  # shellcheck disable=SC2329
  tide_init() {
    exec bash -c "${TIDE_ROOT_DIR}dist/tide init"
  }
}

teardown() {
  :
}

@test 'Listing instances outside of a project fails' {
  run tide_instance_list

  assert_failure
  assert_line 'You are not in a tide project'
}

@test 'A project with no instance says there are no instance' {
  cd "$BATS_TEST_TMPDIR"
  run tide_init

  run tide_instance_list

  assert_success
  assert_line 'No instance in this project'
}

@test 'A project within a git repository with no instance says there are no instance' {
  local git_root_dir && git_root_dir="$BATS_TEST_TMPDIR"
  cd "$git_root_dir"
  git init
  mkdir -p foo/bar
  cd foo/bar

  run tide_init

  run tide_instance_list

  assert_success
  assert_line 'No instance in this project'
}
