main(){
	if [ -z "$ADVG_HUGGING_FACE_TOKEN" ]; then
		echo 'ADVG_HUGGING_FACE_TOKEN variable not set in .env file!' >&2
		exit 1
	fi

	if [ -z "$ADVG_MODEL" ]; then
		echo 'ADVG_MODEL variable not set in .env file!' >&2
		exit 1
	fi
}

main
