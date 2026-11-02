main(){
	docker image rm -f \
				 "${LOCAL_DOCKER_REGISTRY_HOST}:${LOCAL_DOCKER_REGISTRY_PORT}/${LLVM_IMAGE_NAME}"
}

main
