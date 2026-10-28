ensure_model_has_been_fetched(){
	if [ ! -L "${HOME}/inference-setup/$STRIX_HALO_MODEL/$(basename "$STRIX_HALO_MODEL")" ]; then
		echo 'model not found, run make model-fetch first!' >&2
		return 1
	fi
}

run_model() {
	llama-server \
		-m "${HOME}/inference-setup/$STRIX_HALO_MODEL/$(basename "$STRIX_HALO_MODEL")" \
		-ngl 99 \
		-fa on \
		-c 262144 \
		-np 8 \
		-ctk q8_0 \
		-ctv q8_0 \
		-b 4096 \
		-ub 1024 \
		-t 16 \
		--jinja \
		--mlock \
		--no-warmup \
		--no-context-shift \
		--cache-prompt \
		--cache-ram 65536 \
		--host 0.0.0.0 \
		--port "${STRIX_HALO_MODEL_SERVER_PORT}"
}

main(){
	ensure_model_has_been_fetched &&
		run_model
}

main
