FROM alpine:edge AS pinned_world
# NOTE: pinned basic packages in world. Any update will break the build, it is
# intentional
COPY world /etc/apk/world
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  apk fix -U
  apk add \
  bash=5.3.9-r1 \
  shadow=4.18.0-r0
HERE

FROM pinned_world AS user_setup
RUN usermod -s "$(command -v bash)" root

FROM user_setup AS foundation_packages
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

FROM foundation_packages AS install_npm_pckages
RUN \
  --mount=type=tmpfs,target=/tmp <<HERE
  npm config set cache /root/.npm-cache &&
  npm config set prefix /root/.npm-prefix &&
  npm install --global \
  neovim@5.4.0 \
  tree-sitter-cli@0.26.8 &&
  rm -rf /root/.npm
HERE

FROM install_npm_pckages AS install_tree_sitter_lib
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked \
  apk add -t .install_tree_sitter_lib \
  ccmake=4.2.3-r0 \
  clang22=22.1.2-r1 \
  cmake=4.2.3-r0 \
  cmake-doc=4.2.3-r0 \
  lld22=22.1.2-r0 \
  llvm22=22.1.2-r1 \
  musl-dev=1.2.6-r0 \
  samurai=1.2-r8
WORKDIR /root
RUN \
  --mount=type=cache,target=/root \
  rm -rf tree-sitter && \
  git clone \
  --depth=1 \
  --branch=v0.26.8 \
  https://github.com/tree-sitter/tree-sitter.git
WORKDIR /root/tree-sitter
RUN \
  --mount=type=cache,target=/root <<HERE
  cmake \
  -G Ninja \
  -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_AR=llvm22-ar \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_LINKER=ld.lld \
  -DCMAKE_STRIP=llvm22-strip
  cmake --build build
  cmake --install build
HERE

WORKDIR /root
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  apk del .install_tree_sitter_lib &&
  apk fix
HERE

FROM install_tree_sitter_lib AS install_neovim
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  apk add \
  gettext-tiny-dev=0.3.3-r0 \
  libuv-dev=1.51.0-r0 \
  lua5.1=5.1.5-r13 \
  lua5.1-lpeg=1.1.0-r1 \
  luajit-dev=2.1_p20240815-r1 \
  lua-luv-dev=1.51.0.1-r0 \
  unibilium-dev=2.1.1-r2 \
  utf8proc-dev=2.11.3-r0

  apk add -t .install_neovim \
  ccmake=4.2.3-r0 \
  clang22=22.1.2-r1 \
  cmake=4.2.3-r0 \
  cmake-doc=4.2.3-r0 \
  coreutils=9.10-r1 \
  coreutils-doc=9.10-r1 \
  lld22=22.1.2-r0 \
  llvm22=22.1.2-r1 \
  musl-dev=1.2.6-r0 \
  samurai=1.2-r8
HERE

WORKDIR /root
RUN \
  --mount=type=cache,target=/root \
  rm -rf neovim && \
  git clone \
  --depth=1 \
  --branch=v0.12.0 \
  https://github.com/neovim/neovim.git
WORKDIR /root/neovim
RUN \
  --mount=type=cache,target=/root <<HERE
  cmake -G Ninja -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_C_COMPILER_AR=llvm22-ar \
  -DCMAKE_LINKER=ld.lld \
  -DCMAKE_STRIP=llvm22-strip
  cmake --build build
  cmake --install build
HERE

RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  apk del .install_neovim &&
  apk fix
HERE
