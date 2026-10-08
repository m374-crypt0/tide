main(){
	docker image rm -f \
				 "${REGISTRY_HOST}:${REGISTRY_PORT}/${ALPINE_PINNED_IMAGE_NAME}"
}

main
