ARG BASE_STAMP=edge

FROM m374crypt0/tide-alpine-docker:${BASE_STAMP} AS stage_1_packages
ARG USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
    apk add \
    --virtual .stage-1-packages \
    binutils=2.45.1-r1 \
    cmake=4.3.4-r0 \
    libffi-dev=3.8.0-r0 \
    linux-headers=7.2.1-r0 \
    g++=15.2.0-r9 \
    gcc=15.2.0-r9 \
    git=2.55.0-r1 \
    python3=3.14.7-r0 \
    samurai=1.3-r0 \
    zlib-dev=1.3.2-r0 \
    zstd-dev=1.5.7-r2
HERE

USER ${USER_NAME}

FROM stage_1_packages AS clone_repository
ARG USER_NAME=
ARG LLVM_COMMIT=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
RUN git clone --depth 1 --rev=${LLVM_COMMIT} \
    https://github.com/llvm/llvm-project.git	

# TODO: sort cmake variables
FROM clone_repository AS build_stage_1_clang_lld
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
RUN \
    cmake -G Ninja -S llvm -B llvm-build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/home/"${USER_NAME}"/.llvm-stage-1 \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_TARGETS_TO_BUILD="host" \
    -DCLANG_DEFAULT_LINKER=lld \
    -DCLANG_DEFAULT_RTLIB=compiler-rt \
    -DLLVM_ENABLE_ZLIB=FORCE_ON \
    -DCLANG_ENABLE_ARCMT=OFF \
    -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
    -DCLANG_PLUGIN_SUPPORT=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$(gcc -dumpmachine)" && \
    cmake --build llvm-build --target install

FROM clone_repository AS build_stage_2_crt
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
COPY \
    --from=build_stage_1_clang_lld --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-1 /home/${USER_NAME}/.llvm-stage-1
RUN \
    STAGE_1_DIR="/home/${USER_NAME}/.llvm-stage-1" && \
    cmake -G Ninja -S runtimes -B crt-build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DCMAKE_C_COMPILER=/home/${USER_NAME}/.llvm-stage-1/bin/clang \
    -DCMAKE_C_COMPILER_TARGET="$(${STAGE_1_DIR}/bin/clang -print-target-triple)" \
    -DCMAKE_CXX_COMPILER=/home/${USER_NAME}/.llvm-stage-1/bin/clang++ \
    -DCMAKE_INSTALL_PREFIX=/home/${USER_NAME}/.llvm-stage-2 \
    -DCMAKE_LINKER=/home/${USER_NAME}/.llvm-stage-1/bin/ld.lld \
    -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
    -DCOMPILER_RT_BUILD_BUILTINS=ON \
    -DCOMPILER_RT_BUILD_CRT=ON \
    -DCOMPILER_RT_BUILD_MEMPROF=OFF \
    -DCOMPILER_RT_BUILD_PROFILE=OFF \
    -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
    -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
    -DCOMPILER_RT_USE_LIBCXX=ON \
    -DCOMPILER_RT_USE_LLVM_UNWINDER=OFF \
    -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
    -DLIBCXX_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_USE_COMPILER_RT=ON \
    -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$(${STAGE_1_DIR}/bin/clang -print-target-triple)" \
    -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TARGETS_TO_BUILD="host"
RUN cmake --build crt-build --target install

FROM build_stage_2_crt AS build_stage_2_runtimes
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
COPY \
    --from=build_stage_1_clang_lld --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-1 /home/${USER_NAME}/.llvm-stage-1
RUN \
    STAGE_1_DIR="/home/${USER_NAME}/.llvm-stage-1" && \
    STAGE_2_DIR="/home/${USER_NAME}/.llvm-stage-2" && \
    TRIPLE="$(${STAGE_1_DIR}/bin/clang -print-target-triple)" \
    cmake -G Ninja -S runtimes -B runtimes-build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DCMAKE_C_COMPILER=/home/${USER_NAME}/.llvm-stage-1/bin/clang \
    -DCMAKE_C_COMPILER_TARGET="$(${STAGE_1_DIR}/bin/clang -print-target-triple)" \
    -DCMAKE_C_FLAGS="-resource-dir ${STAGE_2_DIR}/${TRIPLE}" \
    -DCMAKE_CXX_COMPILER=/home/${USER_NAME}/.llvm-stage-1/bin/clang++ \
    -DCMAKE_CXX_FLAGS="-resource-dir ${STAGE_2_DIR}/${TRIPLE}" \
    -DCMAKE_INSTALL_PREFIX=${STAGE_2_DIR} \
    -DCMAKE_LINKER=/home/${USER_NAME}/.llvm-stage-1/bin/ld.lld \
    -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
    -DCOMPILER_RT_BUILD_BUILTINS=ON \
    -DCOMPILER_RT_BUILD_CRT=ON \
    -DCOMPILER_RT_BUILD_PROFILE=OFF \
    -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
    -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
    -DCOMPILER_RT_USE_LIBCXX=ON \
    -DCOMPILER_RT_USE_LLVM_UNWINDER=ON \
    -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
    -DLIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=OFF \
    -DLIBCXX_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_USE_COMPILER_RT=ON \
    -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE})" \
    -DLLVM_ENABLE_RUNTIMES="libunwind;libcxxabi;libcxx" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TARGETS_TO_BUILD="host"
RUN cmake --build runtimes-build --target install
