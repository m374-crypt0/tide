ARG NON_ROOT_USER_IMAGE_NAME=localhost:5000/tide-non-root-user
ARG LLVM_IMAGE_NAME=localhost:5000/tide-llvm

FROM ${LLVM_IMAGE_NAME} AS install_packages
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
    --virtual .build_dependencies \
    autoconf=2.73-r0 \
    git=2.56.0-r0 \
		libxml2-dev=2.13.9-r2 \
		linux-headers=7.2.1-r0 \
    make=4.4.1-r4 \
    ncurses-dev=6.6_p20261017-r0 \
    texinfo=7.3-r1 \
    tree-sitter-dev=0.26.7-r1
USER ${NON_ROOT_USER_NAME}

FROM install_packages AS clone_repository
ARG NON_ROOT_USER_NAME=
ARG EMACS_REVISION=
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}"
RUN git clone \
    --depth 1 --rev "${EMACS_REVISION}" \
    https://github.com/emacs-mirror/emacs.git

FROM clone_repository AS build_emacs
ARG NON_ROOT_USER_NAME=
ARG LLVM_OUTPUT_RESOURCE_DIR=
ARG EMACS_OUTPUT_RESOURCE_DIR=
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}/emacs"
RUN ./autogen.sh all && \
    LLVM_DIR="${LLVM_OUTPUT_RESOURCE_DIR}" && \
    CLANG_VER="$(basename "$(ls "${LLVM_DIR}/lib/clang")")" && \
    AR="llvm-ar" \
    CC="clang" \
    CFLAGS="-O3 -resource-dir=${LLVM_DIR}/lib/clang/${CLANG_VER}" \
    CXX="clang++" \
    CXXFLAGS="-O3 -resource-dir=${LLVM_DIR}/lib/clang/${CLANG_VER}" \
    DOCLANGS=en \
    ./configure \
    --prefix="${EMACS_OUTPUT_RESOURCE_DIR}" \
    --with-sound=no \
    --with-pdumper=yes \
    --with-dumping=pdumper \
    --with-x-toolkit=no \
		--with-xml2=yes \
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

FROM ${NON_ROOT_USER_IMAGE_NAME} AS install_emacs
ARG EMACS_OUTPUT_RESOURCE_DIR=
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
    libncursesw=6.6_p20261017-r0 \
		libxml2=2.13.9-r2 \
    ncurses-terminfo-base=6.6_p20261017-r0 \
    tree-sitter=0.26.7-r1
USER ${NON_ROOT_USER_NAME}
WORKDIR /home/${NON_ROOT_USER_NAME}
COPY --chown=${NON_ROOT_USER_NAME} --from=build_emacs \
    "${EMACS_OUTPUT_RESOURCE_DIR}" "${EMACS_OUTPUT_RESOURCE_DIR}"
ENV EMACS_OUTPUT_RESOURCE_DIR=${EMACS_OUTPUT_RESOURCE_DIR}
ENV PATH="${PATH}:${EMACS_OUTPUT_RESOURCE_DIR}/bin"
