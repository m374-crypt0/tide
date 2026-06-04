ensure_initialized_tide_project() {
  if in_git_repository; then
    # NOTE: this variable is setup by bashly and in test cases
    # shellcheck disable=SC2154
    local git && git="${deps[git]}"
    local git_root_dir &&
      git_root_dir="$("$git" rev-parse --show-toplevel 2>/dev/null)"

    if [ ! -d "${git_root_dir}/.tide" ]; then
      echo You are not in a tide project >&2
      return 1
    fi
  elif [ ! -d './.tide' ]; then
    echo You are not in a tide project >&2
    return 1
  fi
}
