ensure_model_has_been_fetched(){
	if [ ! -L "${HOME}/inference-setup/$LIVSH_MODEL/$(basename "$LIVSH_MODEL")" ]; then
		echo 'model not found, run make model-fetch first!' >&2
		return 1
	fi
}

run_model(){
	llama-server \
		-m "${HOME}/inference-setup/$LIVSH_MODEL/$(basename "$LIVSH_MODEL")" \
		--host 0.0.0.0 \
		--port "${LIVSH_MODEL_SERVER_PORT}" \
		--n-gpu-layers 999 \
		--ctx-size 131072 \
		--parallel 1 \
		--flash-attn on \
		--cache-type-k f16 \
		--cache-type-v f16 \
		--jinja \
		--reasoning off \
		--temp 1.0 \
		--top-p 1.0 \
		--top-k 20 \
		--min-p 0 \
		--no-context-shift
}

main(){
	ensure_model_has_been_fetched &&
		run_model
}

main
