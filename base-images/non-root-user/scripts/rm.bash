main(){
	docker image rm -f \
				 "${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}/${NON_ROOT_USER_IMAGE_NAME}"
}

main
