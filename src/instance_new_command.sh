# echo "# This file is located at 'src/instance_new_command.sh'."
# echo "# It contains the implementation for the 'tide instance new' command."
# echo "# The code you write here will be wrapped by a function named 'tide_instance_new_command()'."
# echo "# Feel free to edit this file; your changes will persist when regenerating."
# inspect_args

echo You are not in a tide project >&2
return 1
