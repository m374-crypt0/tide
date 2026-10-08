start_registry_service(){
	make -C "${REGISTRY_ROOT_DIR}" up
}

login_to_registry_service(){
	docker login \
				 -u "$REGISTRY_USER_NAME" \
				 -p "$REGISTRY_USER_PASSWORD" \
				 "http://${REGISTRY_HOST}:$REGISTRY_PORT" \
				 2>/dev/null
}

pull_image(){
	docker compose -f "${DOCKER_IN_DOCKER_ROOT_DIR}/docker/compose.yml" \
				 pull docker-in-docker
}

build_image(){
	docker compose -f "${DOCKER_IN_DOCKER_ROOT_DIR}/docker/compose.yml" \
				 build docker-in-docker
}

main(){
	start_registry_service &&
		login_to_registry_service &&
		( pull_image || build_image )
}

main
