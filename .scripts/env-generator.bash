does_env_file_exist(){
	local project_root_dir="$1"

	[ -f "${project_root_dir}/.env" ]
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
			append_in_env_file "$project_root_dir" ''
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

	does_env_file_exist "$project_root_dir" && return 0
	generate_env_file_content "$project_root_dir"
}
