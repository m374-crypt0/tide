main(){
  docker image rm -f \
    "${REGISTRY_HOST}:${REGISTRY_PORT}/${IDE_WEB_APP_IMAGE_NAME}"
}

main
