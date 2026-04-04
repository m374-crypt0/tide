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
WORKDIR /home/${USER_NAME}

FROM install_docker AS foundation_packages
ARG USER_NAME=
USER root
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked \
  apk add \
  curl=8.19.0-r0 \
  curl-doc=8.19.0-r0 \
  fd=10.2.0-r3 \
  fd-doc=10.2.0-r3 \
  fzf=0.70.0-r0 \
  fzf-doc=0.70.0-r0 \
  git=2.53.0-r1 \
  git-doc=2.53.0-r1 \
  lazygit=0.48.0-r10 \
  lazygit-doc=0.48.0-r10 \
  make=4.4.1-r4 \
  make-doc=4.4.1-r4 \
  man-db=2.13.1-r1 \
  nodejs-current=25.8.2-r0 \
  nodejs-current-doc=25.8.2-r0 \
  npm=11.11.0-r0 \
  npm-doc=11.11.0-r0 \
  ripgrep=15.1.0-r0 \
  ripgrep-doc=15.1.0-r0 \
  tmux=3.6a-r1 \
  tmux-doc=3.6a-r1
USER ${USER_NAME}

FROM foundation_packages AS install_npm_pckages
ARG USER_NAME=
RUN \
  --mount=type=tmpfs,target=/tmp \
  --mount=type=tmpfs,target=/home/${USER_NAME}/.npm-cache <<HERE
  npm config set cache /home/${USER_NAME}/.npm-cache &&
  npm config set prefix /home/${USER_NAME}/.npm-prefix &&
  npm install --global neovim@5.4.0 &&
  rm -rf /home/${USER_NAME}/.npm
HERE

ENV PATH=${PATH}:/home/${USER_NAME}/.npm-prefix/bin

FROM install_npm_pckages AS install_tree_sitter
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
# NOTE: (DL3004) need to figure out why hadolint yells at me for sudo use.
# Anyway, I need to this way because I want to embed all run execution in one
# step to get an optimized image layout.
# NOTE: (DL3003) only one run command and directory switching is part of this
# hadolint ignore=DL3004, DL3003
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  sudo apk add build-base=0.5-r4 &&
  sudo apk add -t .install_tree_sitter \
  ccmake=4.2.3-r0 \
  cmake=4.2.3-r0 \
  cmake-doc=4.2.3-r0 \
  samurai=1.2-r8 \
  cargo=1.94.1-r0 \
  clang22-libclang=22.1.2-r1 &&
  git clone \
  --depth=1 \
  --branch=v0.26.8 \
  https://github.com/tree-sitter/tree-sitter.git &&
  cd tree-sitter &&
  cmake \
  -G Ninja \
  -B build \
  -DCMAKE_BUILD_TYPE=Release &&
  cmake --build build &&
  sudo cmake --install build &&
  cd crates/cli &&
  cargo install --locked tree-sitter-cli &&
  cd /home/${USER_NAME} &&
  rm -rf tree-sitter &&
  sudo apk del .install_tree_sitter &&
  sudo apk fix
HERE

ENV PATH=${PATH}:/home/${USER_NAME}/.cargo/bin

FROM install_tree_sitter AS install_neovim
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
# NOTE: (DL3004) need to figure out why hadolint yells at me for sudo use.
# Anyway, I need to this way because I want to embed all run execution in one
# step to get an optimized image layout.
# NOTE: (DL3003) only one run command and directory switching is part of this
# hadolint ignore=DL3004, DL3003
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  sudo apk add \
  gettext-tiny-dev=0.3.3-r0 &&
  sudo apk add -t .install_neovim \
  ccmake=4.2.3-r0 \
  cmake=4.2.3-r0 \
  coreutils=9.10-r1 \
  linux-headers=6.19.10-r0 \
  samurai=1.2-r8 &&
  git clone \
  --depth=1 \
  --branch=v0.12.0 \
  https://github.com/neovim/neovim.git &&
  cd neovim &&
  cmake -S cmake.deps -B .deps -G Ninja \
  -DCMAKE_BUILD_TYPE=Release &&
  cmake --build .deps &&
  cmake -G Ninja -B build \
  -DCMAKE_BUILD_TYPE=Release &&
  cmake --build build &&
  sudo cmake --install build &&
  sudo apk del .install_neovim &&
  sudo apk fix &&
  cd /home/${USER_NAME} &&
  rm -rf neovim &&
  git clone https://github.com/LazyVim/starter /home/${USER_NAME}/.config/nvim &&
  rm -rf /home/${USER_NAME}/.config/nvim/.git*
HERE

FROM install_neovim AS install_package_for_lazyvim
ARG USER_NAME=
USER ${USER_NAME}
# NOTE: (DL3004) need to figure out why hadolint yells at me for sudo use.
# Anyway, I need to this way because I want to embed all run execution in one
# step to get an optimized image layout.
# hadolint ignore=DL3004
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  sudo apk add \
  python3=3.14.3-r0 \
  python3-doc=3.14.3-r0 \
  gzip=1.14-r2 \
  gzip-doc=1.14-r2 \
  unzip=6.0-r16 \
  unzip-doc=6.0-r16
HERE
