main(){
	docker image rm -f \
				 "${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}/${IDE_MODERN_CPP_IMAGE_NAME}"
}

main
