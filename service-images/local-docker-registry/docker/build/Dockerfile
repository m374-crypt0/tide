ARG LOCAL_DOCKER_REGISTRY_OFFICIAL_REGISTRY_IMAGE_NAME=registry:3

FROM ${LOCAL_DOCKER_REGISTRY_OFFICIAL_REGISTRY_IMAGE_NAME} AS generate_htpasswd
ARG LOCAL_DOCKER_REGISTRY_USER_NAME=
# hadolint ignore=DL3064
ARG LOCAL_DOCKER_REGISTRY_USER_PASSWORD=
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
		apk add apache2-utils=2.4.69-r0
RUN \
		htpasswd -Bbn \
		"${LOCAL_DOCKER_REGISTRY_USER_NAME}" "${LOCAL_DOCKER_REGISTRY_USER_PASSWORD}" \
		> /root/htpasswd

FROM ${LOCAL_DOCKER_REGISTRY_OFFICIAL_REGISTRY_IMAGE_NAME} AS reconfigure_entrypoint
COPY --from=generate_htpasswd /root/htpasswd /root/htpasswd
ENTRYPOINT ["/entrypoint.sh", "/etc/distribution/config.yml"]
