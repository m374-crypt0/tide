main(){
	docker image rm -f \
				 "${REGISTRY_HOST}:${REGISTRY_PORT}/${NON_ROOT_USER_IMAGE_NAME}"
}

main
