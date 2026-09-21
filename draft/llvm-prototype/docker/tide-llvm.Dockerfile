ARG BASE_STAMP=edge

# TODO: user setup must be refactored in its own image
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

FROM user_setup AS install_packages
# hadolint ignore=DL3066
USER root
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
    apk add \
    zlib-dev=1.3.2-r0 \
    zstd-dev=1.5.7-r2
HERE

USER ${USER_NAME}

FROM install_packages AS build_llvm
ARG USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
    apk add -t .builder_packages &&
    apk add \
    git=2.55.0-r1 \
    ccache=4.13.6-r0 \
    ccmake=4.3.4-r0 \
    cmake=4.3.4-r0 \
    gcc=15.2.0-r9 \
    g++=15.2.0-r9 \
    libunwind=1.8.3-r0 \
    linux-headers=7.2.1-r0 \
    musl-dev=1.2.6-r3 \
    python3=3.14.7-r0 \
    samurai=1.3-r0
HERE

WORKDIR /home/${USER_NAME}
RUN su-exec ${USER_NAME} \
    git clone \
    --depth=1 \
    --rev=7d091d586808a91300e653d8ba06dd8406f0fdeb \
    https://github.com/llvm/llvm-project.git

WORKDIR /home/${USER_NAME}/llvm-project
RUN su-exec ${USER_NAME} \
    cmake -S llvm -B build \
    -G Ninja \
    -DCLANG_ENABLE_BOOTSTRAP=On \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/home/${USER_NAME}/.llvm \
    -DLLVM_ENABLE_PROJECTS="clang;lld;clang-tools-extra" \
    -DLLVM_TARGETS_TO_BUILD="host" \
    -DBOOTSTRAP_LLVM_ENABLE_PROJECTS="bolt;clang;clang-tools-extra;lld;lldb;mlir" \
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind;compiler-rt" \
    -DLLVM_CCACHE_BUILD=ON \
    -DBOOTSTRAP_LLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind;compiler-rt;openmp" \
    -DBOOTSTRAP_LLVM_TARGETS_TO_BUILD="all" \
    -DBOOTSTRAP_LLVM_APPEND_VC_REV=ON \
    -DBOOTSTRAP_LLVM_BUILD_LLVM_DYLIB=OFF \
    -DLLVM_ENABLE_EH=ON \
    -DBOOTSTRAP_LLVM_ENABLE_EH=ON \
    -DBOOTSTRAP_LLVM_ENABLE_LIBCXX=ON \
    -DBOOTSTRAP_LLVM_ENABLE_MODULES=OFF \
    -DLLVM_ENABLE_RTTI=ON \
    -DBOOTSTRAP_LLVM_ENABLE_RTTI=ON \
    -DBOOTSTRAP_LLVM_ENABLE_ZLIB=FORCE_ON \
    -DBOOTSTRAP_LLVM_ENABLE_ZSTD=FORCE_ON \
    -DLLVM_ENABLE_ZLIB=FORCE_ON \
    -DLLVM_ENABLE_ZSTD=FORCE_ON \
    -DBOOTSTRAP_LLVM_INCLUDE_BENCHMARKS=OFF \
    -DBOOTSTRAP_LLVM_INCLUDE_EXAMPLES=OFF \
    -DBOOTSTRAP_LLVM_INCLUDE_TESTS=OFF \
    -DBOOTSTRAP_LLVM_INCLUDE_TOOLS=ON \
    -DBOOTSTRAP_LLVM_INSTALL_UTILS=OFF \
    -DLIBUNWIND_ENABLE_SHARED=OFF \
    -DBOOTSTRAP_LIBUNWIND_ENABLE_SHARED=OFF \
    -DLIBCXX_HAS_MUSL_LIBC=ON \
    -DBOOTSTRAP_LIBCXX_HAS_MUSL_LIBC=ON \
    -DCLANG_DEFAULT_RTLIB=compiler-rt \
    -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
    -DLIBCXX_USE_COMPILER_RT=YES \
    -DLIBCXXABI_USE_COMPILER_RT=YES \
    -DLIBCXXABI_USE_LLVM_UNWINDER=YES \
    -DLIBUNWIND_USE_COMPILER_RT=YES \
    -DBOOTSTRAP_CLANG_DEFAULT_RTLIB=compiler-rt \
    -DBOOTSTRAP_CLANG_DEFAULT_CXX_STDLIB=libc++ \
    -DBOOTSTRAP_LIBCXX_USE_COMPILER_RT=YES \
    -DBOOTSTRAP_LIBCXXABI_USE_COMPILER_RT=YES \
    -DBOOTSTRAP_LIBCXXABI_USE_LLVM_UNWINDER=YES \
    -DBOOTSTRAP_LIBUNWIND_USE_COMPILER_RT=YES \
    -DCOMPILER_RT_BUILD_CRT=ON \
    -DCOMPILER_RT_USE_LIBCXX=ON \
    -DBOOTSTRAP_CMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \
    -DBOOTSTRAP_CMAKE_SHARED_LINKER_FLAGS="-fuse-ld=lld" \
    -DBOOTSTRAP_CMAKE_MODULE_LINKER_FLAGS="-fuse-ld=lld" \
    -DBOOTSTRAP_LLVM_USE_HOST_TOOLS=ON
        
FROM build_llvm AS stop

RUN su-exec ${USER_NAME} \
    cmake --build build --target stage2

RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
    apk del .builder_packages &&
    apk fix
HERE

USER ${USER_NAME}
