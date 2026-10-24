main(){
  docker compose -f "${STRIX_HALO_ROOT_DIR}/docker/compose.yml" up -d strix-halo
}

main
