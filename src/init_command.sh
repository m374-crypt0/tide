create_project_in_git_root_directory() {
  # NOTE: this variable is setup by bashly and in test cases
  # shellcheck disable=SC2154
  local git && git="${deps[git]}"
  local root_dir &&
    root_dir="$("$git" rev-parse --show-toplevel 2>/dev/null)"

  if [ -d "${root_dir}/.tide" ]; then
    echo "There is already a tide project in that location: $root_dir" >&2
    return 1
  fi

  mkdir "${root_dir}/.tide"
}

create_project_in_current_directory() {
  if [ -d .tide ]; then
    echo "There is already a tide project in that location: $(pwd)" >&2
    return 1
  fi

  mkdir .tide
}

do_not_ignore_git() {
  # NOTE: args is defined by bashly
  # shellcheck disable=SC2154
  [ "${args["--ignore-git"]}" != 1 ]
}

run() {
  # echo "# This file is located at 'src/init_command.sh'."
  # echo "# It contains the implementation for the 'tide init' command."
  # echo "# The code you write here will be wrapped by a function named 'tide_init_command()'."
  # echo "# Feel free to edit this file; your changes will persist when regenerating."
  # inspect_args

  if in_git_repository && do_not_ignore_git; then
    create_project_in_git_root_directory
  else
    create_project_in_current_directory
  fi
}

run
