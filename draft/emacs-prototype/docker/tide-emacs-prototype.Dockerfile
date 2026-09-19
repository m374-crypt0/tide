ARG BASE_STAMP=edge

FROM m374crypt0/tide-alpine:${BASE_STAMP} AS user_setup
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

FROM user_setup AS install_docker
ARG USER_NAME=
ARG DOCKER_HOST_GID=
# hadolint ignore=DL3066
USER root
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  apk add \
  docker-cli=29.8.1-r0 \
  docker-cli-buildx=0.37.1-r0 \
  docker-cli-compose=5.5.1-r0 &&
  groupadd -g ${DOCKER_HOST_GID} docker &&
  usermod -a -G docker ${USER_NAME}
HERE

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

FROM install_docker AS foundation_packages
ARG USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked \
  apk add \
  git=2.55.0-r1 \
  git-doc=2.55.0-r1 \
  lazygit=0.65.1-r0 \
  lazygit-doc=0.65.1-r0 \
  man-db=2.13.1-r1 \
  nodejs-current=26.8.2-r0 \
  nodejs-current-doc=26.8.2-r0 \
  npm=12.0.2-r0 \
  npm-doc=12.0.2-r0 \
  tmux=3.7c-r0 \
  tmux-doc=3.7c-r0
USER ${USER_NAME}

FROM foundation_packages AS install_emacs
ARG USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked \
  apk add \
  emacs-nox=31.1-r0 \
  emacs-doc=31.1-r0
USER ${USER_NAME}
RUN mkdir /home/${USER_NAME}/.emacs.d
COPY --chown=${USER_NAME} init.el /home/${USER_NAME}/.emacs.d

FROM install_emacs AS install_npm_packages
ARG USER_NAME=
RUN \
  --mount=type=tmpfs,target=/tmp \
  --mount=type=tmpfs,target=/home/${USER_NAME}/.npm-cache <<HERE
  npm config set cache /home/${USER_NAME}/.npm-cache &&
  npm config set prefix /home/${USER_NAME}/.npm-prefix &&
  npm install --global \
    bash-language-server@5.8.0 \
    dockerfile-language-server-nodejs@0.15.0 \
    markdownlint-lsp@0.9.2 \
    yaml-language-server@1.24.0 \
    npm-check-updates@23.1.0 &&
  rm -rf /home/${USER_NAME}/.npm
HERE

ENV PATH=${PATH}:/home/${USER_NAME}/.npm-prefix/bin
