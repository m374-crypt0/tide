main(){
	docker compose -f "${IDE_MODERN_CPP_ROOT_DIR}/docker/compose.yml" up -d shell
}

main
