ensure_script_is_set(){

	if ! docker exec "$STRIX_HALO_CONTAINER_NAME" \
			 [ -f "/home/${NON_ROOT_USER_NAME}/inference-setup/${STRIX_HALO_MODEL}/run.bash" ]; then
		echo \
			'model script is not set up.' \
			'Run make model-set script=<script/path> first!' >&2
		return 1
	fi
}

run_model(){
	docker exec -d "$STRIX_HALO_CONTAINER_NAME" \
				 bash -c \
				 "cd /home/${NON_ROOT_USER_NAME}/inference-setup/${STRIX_HALO_MODEL} && \
				 /home/${NON_ROOT_USER_NAME}/inference-setup/${STRIX_HALO_MODEL}/run.bash"
}

main(){
	ensure_script_is_set &&
		run_model
}

main
