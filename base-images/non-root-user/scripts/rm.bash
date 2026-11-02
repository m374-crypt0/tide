main(){
	docker image rm -f \
				 "${LOCAL_DOCKER_REGISTRY_HOST}:${LOCAL_DOCKER_REGISTRY_PORT}/${NON_ROOT_USER_IMAGE_NAME}"
}

main
