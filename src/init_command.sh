run() {
  # echo "# This file is located at 'src/init_command.sh'."
  # echo "# It contains the implementation for the 'tide init' command."
  # echo "# The code you write here will be wrapped by a function named 'tide_init_command()'."
  # echo "# Feel free to edit this file; your changes will persist when regenerating."
  # inspect_args

  echo "There is already a tide project in that location: $(pwd)" >&2
  return 1
}

run
