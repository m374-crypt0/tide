ARG BASE_STAMP=edge

FROM m374crypt0/tide-alpine-llvm:${BASE_STAMP} AS install_packages
ARG USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
    --virtual .build_dependencies \
    autoconf=2.73-r0 \
    git=2.56.0-r0 \
    linux-headers=7.2.1-r0 \
    make=4.4.1-r4 \
    ncurses-dev=6.6_p20260822-r0 \
    texinfo=7.3-r1 \
    tree-sitter-dev=0.26.7-r1 \
    --virtual .runtime_dependencies
USER ${USER_NAME}

FROM install_packages AS clone_repository
ARG USER_NAME=
ARG EMACS_COMMIT=
USER ${USER_NAME}
WORKDIR "/home/${USER_NAME}"
RUN git clone \
    --depth 1 --rev "${EMACS_COMMIT}" \
    https://github.com/emacs-mirror/emacs.git

FROM clone_repository AS build_emacs
ARG USER_NAME=
WORKDIR "/home/${USER_NAME}/emacs"
RUN ./autogen.sh all && \
    LLVM_DIR="/home/${USER_NAME}/.llvm" && \
    CLANG_VER="$(basename $(ls ${LLVM_DIR}/lib/clang))" && \
    AR=llvm-ar \
    CC=clang \
    CFLAGS="-O3 -resource-dir=${LLVM_DIR}/lib/clang/${CLANG_VER}" \
    CXX=clang++ \
    CXXFLAGS='-O3 -resource-dir=${LLVM_DIR}/lib/clang/${CLANG_VER}' \
    DOCLANGS='en' \
    ./configure \
    --prefix="/home/${USER_NAME}/.emacs" \
    --with-sound=no \
    --with-pdumper=yes \
    --with-dumping=pdumper \
    --with-x-toolkit=no \
    --with-wide-int \
    --without-xpm \
    --without-jpeg \
    --without-tiff \
    --without-png \
    --without-rsvg \
    --without-webp \
    --without-lcms2 \
    --without-libsystemd \
    --without-cairo \
    --without-native-image-api \
    --with-tree-sitter \
    --without-xft \
    --without-harfbuzz \
    --without-libotf \
    --without-m17n-flt \
    --without-toolkit-scroll-bars \
    --without-xaw3d \
    --without-xim \
    --without-xdbe \
    --without-gpm \
    --without-gnutls \
    --without-xinput2 \
    --with-native-compilation=no && \
    make -j"$(nproc)" install

FROM m374crypt0/tide-alpine-llvm:${BASE_STAMP} AS install_emacs
ARG USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
    libncursesw=6.6_p20260822-r0 \
    ncurses-terminfo-base=6.6_p20260822-r0 \
    tree-sitter=0.26.7-r1
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
COPY --chown=${USER_NAME} --from=build_emacs \
    "/home/${USER_NAME}/.emacs" "/home/${USER_NAME}/.emacs"
ENV EMACS_INSTALL_DIR="/home/${USER_NAME}/.emacs"
ENV PATH="${PATH}:${EMACS_INSTALL_DIR}/bin"
