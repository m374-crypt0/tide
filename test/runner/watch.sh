#!/bin/env bash

function run_test() {
  # shellcheck source=/dev/null
  . "${TIDE_ROOT_DIR}test/runner/test.sh"
}

run_test

# TODO: replace with an infinite loop using inotifywatch to avoid multiple
# executions
inotifywait -mqr \
  --event modify \
  "${TIDE_ROOT_DIR}src" \
  --exclude "\.git" |
  while read -r; do
    clear && run_test
  done
