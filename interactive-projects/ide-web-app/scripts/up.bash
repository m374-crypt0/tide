main(){
  docker compose -f "${IDE_WEB_APP_ROOT_DIR}/docker/compose.yml" up -d shell
}

main
