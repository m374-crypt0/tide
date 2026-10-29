main(){
  docker compose -f "${DOCKER_REGISTRY_ROOT_DIR}/docker/compose.yml" up -d registry
}

main
