main(){
  docker image rm -f \
    "${DOCKER_REGISTRY_HOST}:${DOCKER_REGISTRY_PORT}/${IDE_WEB_APP_IMAGE_NAME}"
}

main
