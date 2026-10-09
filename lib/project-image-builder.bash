# TODO: create a pull target in all project Makefiles, remove auto pull
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
	local project_root_dir="$1"
	local service_name="$2"

	docker compose -f "${project_root_dir}/docker/compose.yml" \
				 pull "$service_name"
}

build_image(){
	local project_root_dir="$1"
	local service_name="$2"

	docker compose -f "${project_root_dir}/docker/compose.yml" \
				 build "$service_name"
}

build_project_image(){
	local project_root_dir="$1"
	local service_name="$2"
	
	start_registry_service &&
		login_to_registry_service &&
		( pull_image "$project_root_dir" "$service_name" ||
				build_image "$project_root_dir" "$service_name" )
}
