main(){
	docker compose -f "${REGISTRY_ROOT_DIR}/docker/compose.yml" down registry
}

main
