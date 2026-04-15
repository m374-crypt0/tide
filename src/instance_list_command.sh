run() {
  # echo "# This file is located at 'src/instance_list_command.sh'."
  # echo "# It contains the implementation for the 'tide instance list' command."
  # echo "# The code you write here will be wrapped by a function named 'tide_instance_list_command()'."
  # echo "# Feel free to edit this file; your changes will persist when regenerating."
  # inspect_args

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

  echo 'No instance in this project'
}

run
