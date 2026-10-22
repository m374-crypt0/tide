main(){
	docker image rm -f \
				 "${REGISTRY_HOST}:${REGISTRY_PORT}/${EMACS_IMAGE_NAME}"
}

main
