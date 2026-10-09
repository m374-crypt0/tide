push_image(){
	local image_name="$1"
	
	{
		docker login \
					 -u "${REGISTRY_USER_NAME}" \
					 -p "${REGISTRY_USER_PASSWORD}" \
					 "http://${REGISTRY_HOST}:${REGISTRY_PORT}" \
					 2>/dev/null &&
			docker push "${REGISTRY_HOST}:${REGISTRY_PORT}/$image_name"
	} ||
		echo 'error: push failed. Is registry service running?' >&2
}
