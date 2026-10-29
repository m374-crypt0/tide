main(){
	docker compose -f "${DOCKER_REGISTRY_ROOT_DIR}/docker/compose.yml" down registry
}

main
