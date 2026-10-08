main(){
	docker image rm -f \
				 "${REGISTRY_HOST}:${REGISTRY_PORT}/${REGISTRY_IMAGE_NAME}"
}

main
