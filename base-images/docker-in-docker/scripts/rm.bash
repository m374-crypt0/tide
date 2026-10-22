main(){
	docker image rm -f \
				 "${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}/${DOCKER_IN_DOCKER_IMAGE_NAME}"
}

main
