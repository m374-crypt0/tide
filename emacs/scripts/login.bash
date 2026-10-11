main() {
	docker compose -f "${DOCKER_IN_DOCKER_ROOT_DIR}/docker/compose.yml" \
				 run --rm docker-in-docker bash
}

main
