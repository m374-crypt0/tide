main(){
	docker compose -f "${IDE_ROOT_DIR}/docker/compose.yml" down shell
}

main
