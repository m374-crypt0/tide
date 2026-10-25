hf_auth_login() {
	if ! docker exec -it "${STRIX_HALO_CONTAINER_NAME}" \
			 hf auth login --token "$STRIX_HALO_HUGGING_FACE_TOKEN"; then
		echo 'login failed!' >&2
		return 1
	fi
}

hf_download(){
	local repository file

	repository="$(dirname "$STRIX_HALO_MODEL")"
	file="$(basename "$STRIX_HALO_MODEL")"

	if ! docker exec -it "$STRIX_HALO_CONTAINER_NAME" \
			 hf download "$repository" "$file"; then
		echo 'model downloaf failed!' >&2
		return 1
	fi
}

create_symlink(){
	docker exec "$STRIX_HALO_CONTAINER_NAME" \
				 mkdir -p \
				 "/home/${NON_ROOT_USER_NAME}/inference-setup/$STRIX_HALO_MODEL"

	local file
	file="$(basename "$STRIX_HALO_MODEL")"

	docker exec "$STRIX_HALO_CONTAINER_NAME" \
				 find "/home/${NON_ROOT_USER_NAME}/.cache/huggingface" \
				 -type l -name "$file" |
		{
			local path
			read -r path
			docker exec "$STRIX_HALO_CONTAINER_NAME" \
						 ln -sf \
						 "$path" \
						 "/home/${NON_ROOT_USER_NAME}/inference-setup/${STRIX_HALO_MODEL}/$file"
		}
}

main() {
	hf_auth_login &&
		hf_download &&
		create_symlink
}

main
