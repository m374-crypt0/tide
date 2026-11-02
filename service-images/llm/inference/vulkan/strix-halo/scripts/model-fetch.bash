hf_auth_login() {
	if ! docker exec -it "${LIVSH_CONTAINER_NAME}" \
			 hf auth login --token "$LIVSH_HUGGING_FACE_TOKEN"; then
		echo 'login failed!' >&2
		return 1
	fi
}

hf_download(){
	local repository file

	repository="$(dirname "$LIVSH_MODEL")"
	file="$(basename "$LIVSH_MODEL")"

	if ! docker exec -it "$LIVSH_CONTAINER_NAME" \
			 hf download "$repository" "$file"; then
		echo 'model downloaf failed!' >&2
		return 1
	fi
}

create_symlink(){
	docker exec "$LIVSH_CONTAINER_NAME" \
				 mkdir -p \
				 "/home/${NON_ROOT_USER_NAME}/inference-setup/$LIVSH_MODEL"

	local file
	file="$(basename "$LIVSH_MODEL")"

	docker exec "$LIVSH_CONTAINER_NAME" \
				 find "/home/${NON_ROOT_USER_NAME}/.cache/huggingface" \
				 -type l -name "$file" |
		{
			local path
			read -r path
			docker exec "$LIVSH_CONTAINER_NAME" \
						 ln -sf \
						 "$path" \
						 "/home/${NON_ROOT_USER_NAME}/inference-setup/${LIVSH_MODEL}/$file"
		}
}

main() {
	hf_auth_login &&
		hf_download &&
		create_symlink
}

main
