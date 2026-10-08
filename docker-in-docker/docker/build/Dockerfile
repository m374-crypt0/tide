ARG NON_ROOT_USER_IMAGE_NAME=localhost:5000/tide-non-root-user

FROM ${NON_ROOT_USER_IMAGE_NAME} AS install_docker
ARG NON_ROOT_USER_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
		apk add \
    docker-cli=29.8.2-r0 \
    docker-cli-buildx=0.37.2-r0 \
    docker-cli-compose=5.6.0-r0 \
    docker-doc=29.8.2-r0
USER ${NON_ROOT_USER_USER_NAME}

FROM install_docker AS modify_non_root_user
ARG NON_ROOT_USER_NAME=
ARG DOCKER_IN_DOCKER_DOCKER_GID=
# hadolint ignore=DL3066
USER root
RUN	groupadd -g ${DOCKER_IN_DOCKER_DOCKER_GID} docker && \
		usermod -a -G docker ${NON_ROOT_USER_NAME}
USER ${NON_ROOT_USER_NAME}
WORKDIR /home/${NON_ROOT_USER_NAME}
