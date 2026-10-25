find_model_run_script_pid(){
	docker exec "$STRIX_HALO_CONTAINER_NAME" \
				 pgrep -f \
				 "/home/${NON_ROOT_USER_NAME}/inference-setup/${STRIX_HALO_MODEL}/run.bash"
}

find_llama_server_pid(){
	local ppid &&
		while IFS= read -r ppid; do
			docker exec "$STRIX_HALO_CONTAINER_NAME" \
						 pgrep -P "$ppid"
		done
}

kill_llama_server(){
	local pid &&
		while IFS= read -r pid; do
			docker exec "$STRIX_HALO_CONTAINER_NAME" \
						 kill "$pid"
		done
}

main(){
	find_model_run_script_pid |
		find_llama_server_pid |
		kill_llama_server
}

main
