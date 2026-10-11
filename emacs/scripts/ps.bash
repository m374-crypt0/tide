main(){
	docker compose -f "${EMACS_ROOT_DIR}/docker/compose.yml" ps
}

main
