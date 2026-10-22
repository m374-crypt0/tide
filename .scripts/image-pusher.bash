push_image(){
	local image_name="$1"
	
	{
		docker login \
					 -u "${DOCKER_REGISTRY_USER_NAME}" \
					 -p "${DOCKER_REGISTRY_USER_PASSWORD}" \
					 "http://${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}" \
					 2>/dev/null &&
			docker push "${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}/$image_name"
	} ||
		echo 'error: push failed. Is registry service running?' >&2
}
