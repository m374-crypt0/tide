main(){
	docker image rm -f \
				 "localhost:${REGISTRY_PORT}/${ALPINE_PINNED_IMAGE_NAME}"
}

main
