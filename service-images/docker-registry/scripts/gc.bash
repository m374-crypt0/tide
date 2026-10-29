main(){
  docker compose \
    -f "${DOCKER_REGISTRY_ROOT_DIR}/docker/compose.yml" \
    exec registry \
    registry garbage-collect /etc/distribution/config.yml
}

main
