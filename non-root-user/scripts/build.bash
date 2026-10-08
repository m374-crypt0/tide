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
	docker compose -f "${NON_ROOT_USER_ROOT_DIR}/docker/compose.yml" \
				 pull non-root-user
}

build_image(){
	docker compose -f "${NON_ROOT_USER_ROOT_DIR}/docker/compose.yml" \
				 build non-root-user
}

main(){
	start_registry_service &&
		login_to_registry_service &&
		( pull_image || build_image )
}

main
