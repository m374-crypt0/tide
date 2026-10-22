main(){
	docker image rm -f \
				 "${REGISTRY_HOST}:${REGISTRY_PORT}/${LLVM_IMAGE_NAME}"
}

main
