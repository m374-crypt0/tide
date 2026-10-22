main(){
	docker image rm -f \
				 "${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}/${ALPINE_PINNED_IMAGE_NAME}"
}

main
