main(){
	docker compose -f "${LIVSH_ROOT_DIR}/docker/compose.yml" down livsh
}

main
