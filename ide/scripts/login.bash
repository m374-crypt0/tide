main() {
	docker compose -f "${IDE_ROOT_DIR}/docker/compose.yml" \
				 exec -it shell bash
}

main
