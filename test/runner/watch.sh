#!/bin/env bash

function run_test() {
  # shellcheck source=/dev/null
  . "${TIDE_ROOT_DIR}test/runner/test.sh"
}

while true; do
  inotifywait -mqr \
    --event modify \
    "${TIDE_ROOT_DIR}test" \
    "${TIDE_ROOT_DIR}src" |
    {
      clear && run_test
    }
done
