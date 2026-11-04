main(){
  docker image rm -f \
	"${LOCAL_DOCKER_REGISTRY_HOST}:${LOCAL_DOCKER_REGISTRY_PORT}/${ADVG_IMAGE_NAME}"
}

main
