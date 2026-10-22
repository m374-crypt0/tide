main(){
	docker compose -f "${LLVM_ROOT_DIR}/docker/compose.yml" ps
}

main
