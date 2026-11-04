hf_auth_login() {
  if ! docker exec -it "${ADVG_CONTAINER_NAME}" \
	hf auth login --token "$ADVG_HUGGING_FACE_TOKEN"; then
	echo 'login failed!' >&2
	return 1
  fi
}

hf_download(){
  local repository file

  repository="$(dirname "$ADVG_MODEL")"
  file="$(basename "$ADVG_MODEL")"

  if ! docker exec -it "$ADVG_CONTAINER_NAME" \
	hf download "$repository" "$file"; then
	echo 'model download failed!' >&2
	return 1
  fi
}

create_symlink(){
  docker exec "$ADVG_CONTAINER_NAME" \
	mkdir -p \
	"/home/${NON_ROOT_USER_NAME}/decoding-setup/$ADVG_MODEL"

  local file
  file="$(basename "$ADVG_MODEL")"
  
  docker exec "$ADVG_CONTAINER_NAME" \
	find "/home/${NON_ROOT_USER_NAME}/.cache/huggingface" \
	-type l -name "$file" |
	{
	  local path
	  read -r path
	  docker exec "$ADVG_CONTAINER_NAME" \
		ln -sf \
		"$path" \
		"/home/${NON_ROOT_USER_NAME}/decoding-setup/${ADVG_MODEL}/$file"
	}
}

main() {
  hf_auth_login &&
	hf_download &&
	create_symlink
}

main
