main(){
  docker compose -f "${ADVG_ROOT_DIR}/docker/compose.yml" up -d advg
}

main
