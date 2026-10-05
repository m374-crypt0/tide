#!/bin/env bash

assert_not_declared_as_path_in() {
  local file && file="$1"

  [ ! -f "$file" ] &&
    return 0

  local val && val="$2"

  # shellcheck source=/dev/null
  . "$file"

  [[ ! "$val" == *":${PATH}:"* ]]
}

assert_declared_as_path_in() {
  local file && file="$1"

  [ ! -f "$file" ] &&
    return 1

  local val && val="$2"

  # shellcheck source=/dev/null
  . "$file"

  [[ ":${PATH}:" == *":${val}:"* ]]
}
