main(){
	docker compose -f "${DOCKER_IN_DOCKER_ROOT_DIR}/docker/compose.yml" ps
}

main
