main(){
	docker image rm -f \
				 "localhost:${REGISTRY_PORT}/${NON_ROOT_USER_IMAGE_NAME}"
}

main
