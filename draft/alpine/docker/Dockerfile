FROM alpine:edge AS pinned_world
# NOTE: pinned basic packages in world. Any update will break the build, it is
# intentional
COPY world /etc/apk/world
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  apk fix -U
  apk add \
  bash=5.3.9-r1 \
  shadow=4.18.0-r0 \
  sudo=1.9.17_p2-r1 \
  sudo-doc=1.9.17_p2-r1
HERE

FROM pinned_world AS user_setup
USER root
ARG USER_UID=0
ARG USER_GID=0
ARG USER_NAME=root
RUN <<HERE
  groupadd -g ${USER_GID} ${USER_NAME} &&
  useradd -d /home/${USER_NAME} -u ${USER_UID} -g ${USER_GID} -m -s /bin/bash -l ${USER_NAME} &&
  echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME}
HERE

USER ${USER_NAME}
# NOTE: might be root, in that case home dir is not a subdir of /home
# hadolint ignore=DL3003
RUN cd || exit $?

FROM user_setup AS install_docker
ARG USER_NAME=root
ARG DOCKER_HOST_GID=
USER root
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  apk add \
  docker-cli=29.3.1-r0 \
  docker-cli-buildx=0.32.1-r0 \
  docker-cli-compose=5.1.1-r0 &&
  groupadd -g ${DOCKER_HOST_GID} docker &&
  usermod -a -G docker ${USER_NAME}
HERE

USER ${USER_NAME}
