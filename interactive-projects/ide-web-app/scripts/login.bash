main() {
	docker compose -f "${IDE_WEB_APP_ROOT_DIR}/docker/compose.yml" \
				 exec -it shell bash
}

main
