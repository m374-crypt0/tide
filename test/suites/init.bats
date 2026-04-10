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
  init_command() {
    declare -A deps

    # NOTE: used as placeholder, normally these arrays is defined by bashly
    # shellcheck disable=SC2034
    deps=([git]=git)

    load "${TIDE_ROOT_DIR}src/init_command.sh"
  }
}

teardown() {
  :
}

@test 'Cannot init a project if a project already exists in a non git repository' {
  local project_location && project_location="${BATS_TEST_TMPDIR}"
  cd "$project_location"
  mkdir "${project_location}/.tide"

  run init_command

  assert_failure
  assert_line "There is already a tide project in that location: $project_location"
}

@test 'Cannot init a project if a project already exist in git directory hierarchy' {
  local project_location && project_location="${BATS_TEST_TMPDIR}"
  cd "$project_location"
  git init
  mkdir -p foo/bar
  mkdir "${project_location}/.tide"
  cd foo/bar

  run init_command

  assert_failure
  assert_line "There is already a tide project in that location: $project_location"
}

@test 'Can init a project in a non git repository in the current working directory' {
  local project_location && project_location="${BATS_TEST_TMPDIR}/.tide"
  cd "$BATS_TEST_TMPDIR"

  run init_command

  assert_dir_exists "$project_location"
}

@test 'Can init a project at the root of a git repository' {
  local project_location && project_location="${BATS_TEST_TMPDIR}"
  cd "$project_location"
  git init
  mkdir -p foo/bar
  cd foo/bar

  run init_command

  assert_dir_exists "${project_location}/.tide"
}

@test 'Initializing a project ignoring git outside of a git repository has no effect' {
  skip
}
