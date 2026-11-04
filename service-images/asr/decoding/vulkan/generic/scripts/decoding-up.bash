ensure_script_is_set(){
  if ! docker exec "$ADVG_CONTAINER_NAME" \
	[ -f "/home/${NON_ROOT_USER_NAME}/decoding-setup/${ADVG_MODEL}/run.bash" ]; then
	echo \
	  'model script is not set up.' \
	  'Run make model-set script=<script/path> first!' >&2
	return 1
  fi
}

run_model(){
  echo 'model is loading. Press CTRL-C to detach log output.'

  docker exec "$ADVG_CONTAINER_NAME" \
	bash -c "/home/${NON_ROOT_USER_NAME}/decoding-setup/${ADVG_MODEL}/run.bash"
}

main(){
  ensure_script_is_set &&
	run_model
}

main
