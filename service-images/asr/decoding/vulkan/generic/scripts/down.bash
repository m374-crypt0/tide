main(){
	docker compose -f "${ADVG_ROOT_DIR}/docker/compose.yml" down advg
}

main
