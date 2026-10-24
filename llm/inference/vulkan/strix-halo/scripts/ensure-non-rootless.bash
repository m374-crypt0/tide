#!/bin/env bash

get_docker_socket(){
	local socket_uri &&
		socket_uri="$(docker context inspect --format '{{.Endpoints.docker.Host}}')"

	echo "${socket_uri#unix://}"
}

expects(){
	local expected &&
		expected="$1"

	local read_value &&
		read -r read_value

	[ "$expected" == "$read_value" ]
}

ensure_docker_socket_owner_is_root(){
  local socket &&
		read -r socket

	stat -c '%u' "$socket" |
		expects '0'
}

error_with(){
	local message &&
		message="$1"

	echo "$message"
	return 1
}

main(){
	get_docker_socket |
		ensure_docker_socket_owner_is_root ||
		error_with 'docker rootless mode is not supported'
}

main
