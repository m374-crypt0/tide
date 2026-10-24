main(){
	docker image rm -f \
				 "${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}/${STRIX_HALO_IMAGE_NAME}"
}

main
