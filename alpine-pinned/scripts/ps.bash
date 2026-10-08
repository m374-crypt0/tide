main(){
	docker compose -f "${ALPINE_PINNED_ROOT_DIR}/docker/compose.yml" ps
}

main
