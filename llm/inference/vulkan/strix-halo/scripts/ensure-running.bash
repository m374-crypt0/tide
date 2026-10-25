main(){
	local container_id&&
		container_id="$(docker ps -q --filter "name=$STRIX_HALO_CONTAINER_NAME")"

	if [ -z "$container_id" ];then
		echo 'service stopped. Do make up first!' >&2
		exit 1
	fi
}

main
