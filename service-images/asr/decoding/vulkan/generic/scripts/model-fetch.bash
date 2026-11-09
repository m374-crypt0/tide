hf_auth_login() {
  if ! docker exec -it "${ADVG_CONTAINER_NAME}" \
	hf auth login --token "$ADVG_HUGGING_FACE_TOKEN"; then
	echo 'login failed!' >&2
	return 1
  fi
}

hf_download_model(){
  local var && var="$1"
	local repository file

  repository="$(dirname "$var")"
  file="$(basename "$var")"

  if ! docker exec -it "$ADVG_CONTAINER_NAME" \
	     hf download "$repository" "$file"; then
	  echo 'model download failed!' >&2
	  return 1
  fi
}

hf_download_models(){
	hf_download_model "$ADVG_MODEL" &&
		hf_download_model "$ADVG_VAD_MODEL"
}

create_symlink(){
	local var && var="$1"

	docker exec "$ADVG_CONTAINER_NAME" \
	mkdir -p \
	"/home/${NON_ROOT_USER_NAME}/decoding-setup/$var"

  local file
  file="$(basename "$var")"
  
  docker exec "$ADVG_CONTAINER_NAME" \
	find "/home/${NON_ROOT_USER_NAME}/.cache/huggingface" \
	-type l -name "$file" |
	{
	  local path
	  read -r path
	  docker exec "$ADVG_CONTAINER_NAME" \
		ln -sf \
		"$path" \
		"/home/${NON_ROOT_USER_NAME}/decoding-setup/${var}/$file"
	}
}

create_symlinks(){
	create_symlink "$ADVG_MODEL" &&
		create_symlink "$ADVG_VAD_MODEL"
}

main() {
  hf_auth_login &&
	hf_download_models &&
	create_symlinks
}

main
