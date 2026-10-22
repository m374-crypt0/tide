main(){
	docker image rm -f \
				 "${REGISTRY_HOST}:${REGISTRY_PORT}/${DOCKER_IN_DOCKER_IMAGE_NAME}"
}

main
