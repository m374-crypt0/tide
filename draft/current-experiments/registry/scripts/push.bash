main(){
	docker login \
				 -u "${REGISTRY_USER_NAME}" \
				 -p "${REGISTRY_USER_PASSWORD}" 2>/dev/null \
				 "http://localhost:${REGISTRY_PORT}"

	docker push "localhost:${REGISTRY_PORT}/${REGISTRY_IMAGE_NAME}"
}

main
