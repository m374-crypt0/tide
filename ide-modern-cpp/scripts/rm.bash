main(){
	docker image rm -f \
				 "${REGISTRY_HOST}:${REGISTRY_PORT}/${IDE_MODERN_CPP_IMAGE_NAME}"
}

main
