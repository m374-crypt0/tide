# shellcheck source=/dev/null
. "${TIDE_ROOT_DIR}/.scripts/image-pusher.bash"

push_image "$NON_ROOT_USER_IMAGE_NAME"

main(){
	docker login \
				 -u "${DOCKER_REGISTRY_USER_NAME}" \
				 -p "${DOCKER_REGISTRY_USER_PASSWORD}" \
				 "http://${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}" \
				 2>/dev/null &&
		docker push "${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}/${NON_ROOT_USER_IMAGE_NAME}"
}

main
