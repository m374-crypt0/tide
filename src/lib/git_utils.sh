in_git_repository() {
  # NOTE: following check disabled, deps managed by bashly
  # shellcheck disable=SC2154
  local git && git="${deps[git]}"

  "$git" rev-parse --show-toplevel 2>/dev/null 1>&2
}
