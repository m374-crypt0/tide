pull_image(){
	local image_name="$1"
	
	{
		docker login \
					 -u "${REGISTRY_USER_NAME}" \
					 -p "${REGISTRY_USER_PASSWORD}" \
					 "http://${REGISTRY_HOST}:${REGISTRY_PORT}" \
					 2>/dev/null &&
			docker pull \
						 "${REGISTRY_HOST}:${REGISTRY_PORT}/$image_name"
	} ||
		echo 'error: pull failed. Is registry service running?' >&2
}
