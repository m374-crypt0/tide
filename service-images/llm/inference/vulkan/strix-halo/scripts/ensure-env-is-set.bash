main(){
	if [ -z "$STRIX_HALO_HUGGING_FACE_TOKEN" ]; then
		echo 'STRIX_HALO_HUGGING_FACE_TOKEN variable not set in .env file!' >&2
		exit 1
	fi

	if [ -z "$STRIX_HALO_MODEL" ]; then
		echo 'STRIX_HALO_MODEL variable not set in .env file!' >&2
		exit 1
	fi
}

main
