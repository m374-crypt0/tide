run() {
  # echo "# This file is located at 'src/instance_list_command.sh'."
  # echo "# It contains the implementation for the 'tide instance list' command."
  # echo "# The code you write here will be wrapped by a function named 'tide_instance_list_command()'."
  # echo "# Feel free to edit this file; your changes will persist when regenerating."
  # inspect_args

  if [ ! -d './.tide' ]; then
    echo You are not in a tide project >&2
    exit 1
  fi

  echo 'No instance in this project'
}

run
