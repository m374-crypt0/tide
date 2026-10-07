ARG REGISTRY_OFFICIAL_REGISTRY_IMAGE_NAME=registry:3

FROM ${REGISTRY_OFFICIAL_REGISTRY_IMAGE_NAME} AS generate_htpasswd
ARG REGISTRY_USER_NAME=
# hadolint ignore=DL3064
ARG REGISTRY_USER_PASSWORD=
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
		apk add apache2-utils=2.4.69-r0
RUN \
		htpasswd -Bbn \
		"${REGISTRY_USER_NAME}" "${REGISTRY_USER_PASSWORD}" \
		> /root/htpasswd

FROM ${REGISTRY_OFFICIAL_REGISTRY_IMAGE_NAME} AS end
COPY --from=generate_htpasswd /root/htpasswd /root/htpasswd
ENTRYPOINT ["/entrypoint.sh"]
