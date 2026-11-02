main(){
  docker compose -f "${LIVSH_ROOT_DIR}/docker/compose.yml" up -d livsh
}

main
