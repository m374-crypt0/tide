main(){
	docker image rm -f \
				 "localhost:${REGISTRY_PORT}/${REGISTRY_IMAGE_NAME}"
}

main
