push_image(){
  local image_name&& image_name="$1"
	
  docker push "${LOCAL_DOCKER_REGISTRY_HOST}:${LOCAL_DOCKER_REGISTRY_PORT}/$image_name"	 || {
	echo 'error: push failed. Is registry service running?' >&2
	return 1
  }
}
