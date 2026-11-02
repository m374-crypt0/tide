ensure_model_has_been_dowloaded(){
	local file
	file="$(basename "$LIVSH_MODEL")"

	if  ! docker exec "$LIVSH_CONTAINER_NAME" \
				[ -L "/home/${NON_ROOT_USER_NAME}/inference-setup/${LIVSH_MODEL}/$file" ]; then
		echo 'the model has not yet been downloaded, run make model-fetch first!' >&2
		return 1
	fi
}

validate_user_script(){
	if [ -z "$script" ];then
		echo 'script must be specified: make model-set script=path/to/script' >&2
		return 1
	fi

	if [ ! -f "$script" ];then
		echo "script <$script> does not exist!" >&2
		return 1
	fi
}

cache_script() {
	docker cp \
				 "$script" \
				 "$LIVSH_CONTAINER_NAME":"/home/${NON_ROOT_USER_NAME}/inference-setup/$LIVSH_MODEL/run.bash" && \
		docker exec "$LIVSH_CONTAINER_NAME" \
					 chmod +x "/home/${NON_ROOT_USER_NAME}/inference-setup/$LIVSH_MODEL/run.bash"
}

main() {
	ensure_model_has_been_dowloaded &&
		validate_user_script &&
		cache_script
}

main
