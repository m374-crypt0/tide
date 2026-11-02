main(){
	docker image rm -f \
				 "${LOCAL_DOCKER_REGISTRY_HOST}:${LOCAL_DOCKER_REGISTRY_PORT}/${IDE_MODERN_CPP_IMAGE_NAME}"
}

main
