build_image(){
	local project_root_dir="$1"
	local service_name="$2"

	docker compose -f "${project_root_dir}/docker/compose.yml" \
				 build "$service_name"
}

build_project_image(){
	local project_root_dir="$1"
	local service_name="$2"
	
	build_image "$project_root_dir" "$service_name"
}
