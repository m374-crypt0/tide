main(){
	docker image rm -f \
				 "${REGISTRY_HOST}:${REGISTRY_PORT}/${IDE_IMAGE_NAME}"
}

main
