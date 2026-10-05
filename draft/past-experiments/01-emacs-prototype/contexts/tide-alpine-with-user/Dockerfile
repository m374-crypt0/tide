ARG BASE_STAMP=edge

FROM m374crypt0/tide-alpine-pinned:${BASE_STAMP} AS with_user
# hadolint ignore=DL3066
USER root
ARG USER_UID=
ARG USER_GID=
ARG USER_NAME=
RUN <<HERE
  groupadd -g ${USER_GID} ${USER_NAME} &&
  useradd -d /home/${USER_NAME} -u ${USER_UID} -g ${USER_GID} -m -s /bin/bash -l ${USER_NAME} &&
  echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME}
HERE

USER ${USER_NAME}
