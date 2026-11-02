main(){
  docker image rm -f \
    "${LOCAL_DOCKER_REGISTRY_HOST}:${LOCAL_DOCKER_REGISTRY_PORT}/${IDE_WEB_APP_IMAGE_NAME}"
}

main
