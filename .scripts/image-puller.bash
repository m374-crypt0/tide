pull_image(){
	local image_name="$1"
	
	{
		docker login \
					 -u "${LOCAL_DOCKER_REGISTRY_USER_NAME}" \
					 -p "${LOCAL_DOCKER_REGISTRY_USER_PASSWORD}" \
					 "http://${LOCAL_DOCKER_REGISTRY_HOST}:${LOCAL_DOCKER_REGISTRY_PORT}" \
					 2>/dev/null &&
			docker pull \
						 "${LOCAL_DOCKER_REGISTRY_HOST}:${LOCAL_DOCKER_REGISTRY_PORT}/$image_name"
	} || {
		echo 'error: pull failed. Is registry service running?' >&2
		return 1
	}
}
