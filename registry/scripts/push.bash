main(){
	docker login \
				 -u "${REGISTRY_USER_NAME}" \
				 -p "${REGISTRY_USER_PASSWORD}" \
				 "http://localhost:${REGISTRY_PORT}" \
				 2>/dev/null &&
		docker push "localhost:${REGISTRY_PORT}/${REGISTRY_IMAGE_NAME}"
}

main
