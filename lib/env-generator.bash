exit_if_env_file_exists(){
	local project_root_dir="$1"

	[ ! -f "${project_root_dir}/.env" ] || exit 0
}

append_in_env_file() {
	local project_root_dir="$1"
	local line="$2"

	echo "$line" >> "${project_root_dir}/.env"
}

generate_env_file_content(){
	local project_root_dir="$1"

	# shellcheck source=/dev/null
	. "${project_root_dir}/.env.defaults"

	local line
	while IFS='' read -r line; do
		if [ -z "$line" ]; then
			continue
		fi

		if [[ "$line" =~ ^[[:space:]]*# ]]; then
			append_in_env_file "$project_root_dir" "$line"
			continue
		fi

		local variable
		IFS='=' read -r variable _ <<< "$line"
		append_in_env_file "$project_root_dir" "$variable=${!variable}"
	done <<< "$(cat "${project_root_dir}/.env.defaults")"
}

generate_env_file_in(){
	local project_root_dir="$1"

	exit_if_env_file_exists "$project_root_dir"
	generate_env_file_content "$project_root_dir"

}
