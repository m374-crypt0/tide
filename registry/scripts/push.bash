main(){
	docker login \
				 -u "${REGISTRY_USER_NAME}" \
				 -p "${REGISTRY_USER_PASSWORD}" \
				 "http://${REGISTRY_HOST}:${REGISTRY_PORT}" \
				 2>/dev/null &&
		docker push "${REGISTRY_HOST}:${REGISTRY_PORT}/${REGISTRY_IMAGE_NAME}"
}

main
