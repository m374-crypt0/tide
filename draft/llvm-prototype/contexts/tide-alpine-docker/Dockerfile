ARG BASE_STAMP=edge

FROM m374crypt0/tide-alpine-with-user:${BASE_STAMP} AS install_docker
ARG USER_NAME=
ARG DOCKER_HOST_GID=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
    apk add \
    docker-cli=29.8.1-r0 \
    docker-cli-buildx=0.37.1-r0 \
    docker-cli-compose=5.5.1-r0 \
    docker-doc=29.8.1-r0 &&
    groupadd -g ${DOCKER_HOST_GID} docker &&
    usermod -a -G docker ${USER_NAME}
HERE

USER ${USER_NAME}
