main() {
	docker compose -f "${IDE_MODERN_CPP_ROOT_DIR}/docker/compose.yml" \
				 exec -it shell bash
}

main
