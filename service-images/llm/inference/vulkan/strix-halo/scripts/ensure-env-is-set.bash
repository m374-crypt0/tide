main(){
	if [ -z "$LIVSH_HUGGING_FACE_TOKEN" ]; then
		echo 'LIVSH_HUGGING_FACE_TOKEN variable not set in .env file!' >&2
		exit 1
	fi

	if [ -z "$LIVSH_MODEL" ]; then
		echo 'LIVSH_MODEL variable not set in .env file!' >&2
		exit 1
	fi
}

main
