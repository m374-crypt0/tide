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
    declare -A deps

    # NOTE: used as placeholder, normally these arrays is defined by bashly
    # shellcheck disable=SC2034
    deps=([git]=git)

    load "${TIDE_ROOT_DIR}src/lib/git_utils.sh"
    load "${TIDE_ROOT_DIR}src/instance_list_command.sh"
  }

  # shellcheck disable=SC2329
  init_command() {
    declare -A deps

    # NOTE: used as placeholder, normally these arrays is defined by bashly
    # shellcheck disable=SC2034
    deps=([git]=git)

    load "${TIDE_ROOT_DIR}src/lib/git_utils.sh"
    load "${TIDE_ROOT_DIR}src/init_command.sh"
  }
}

teardown() {
  :
}

@test 'Listing instances outside of a project fails' {
  run instance_list_command

  assert_failure
  assert_line 'You are not in a tide project'
}

@test 'A project with no instance says there are no instance' {
  cd "$BATS_TEST_TMPDIR"
  run init_command

  run instance_list_command

  assert_success
  assert_line 'No instance in this project'
}

@test 'A project within a git repository with no instance says there are no instance' {
  local git_root_dir && git_root_dir="$BATS_TEST_TMPDIR"
  cd "$git_root_dir"
  git init
  mkdir -p foo/bar
  cd foo/bar

  run init_command

  run instance_list_command

  assert_success
  assert_line 'No instance in this project'
}
