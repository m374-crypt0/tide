main(){
	docker compose -f "${LOCAL_DOCKER_REGISTRY_ROOT_DIR}/docker/compose.yml" down registry
}

main
