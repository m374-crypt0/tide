exit_if_env_file_exists(){
	[ ! -f "${ALPINE_PINNED_ROOT_DIR}/.env" ] || exit 0
}

append_in_env_file() {
	local line="$1"

	echo "$line" >> "${ALPINE_PINNED_ROOT_DIR}/.env"
}

generate_env_file(){
	# shellcheck source=/dev/null
	. "${ALPINE_PINNED_ROOT_DIR}/.env.defaults"

	local line
	while IFS='' read -r line; do
		if [ -z "$line" ]; then
			continue
		fi
		
		if [[ "$line" =~ ^[[:space:]]*# ]]; then
			append_in_env_file "$line"
			continue
		fi
		
		local variable
		IFS='=' read -r variable _ <<< "$line"
		append_in_env_file "$variable=${!variable}"
	done <<< "$(cat "${ALPINE_PINNED_ROOT_DIR}/.env.defaults")"
}

main(){
	exit_if_env_file_exists
	generate_env_file
}

main
