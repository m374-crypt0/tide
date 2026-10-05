# echo "# This file is located at 'src/instance_new_command.sh'."
# echo "# It contains the implementation for the 'tide instance new' command."
# echo "# The code you write here will be wrapped by a function named 'tide_instance_new_command()'."
# echo "# Feel free to edit this file; your changes will persist when regenerating."
# inspect_args

ensure_template_exist() {
  echo "the template ${1} does not exist" >&2
  return 1
}

create_instance() {
  :
}

main() {
  # NOTE: this variable is setup by bashly and in test cases
  # shellcheck disable=SC2154
  local template && template="${args[--template]}"

  ensure_initialized_tide_project &&
    ensure_template_exist "$template" &&
    create_instance "$template"
}

main
