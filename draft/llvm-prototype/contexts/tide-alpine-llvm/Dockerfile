ARG BASE_STAMP=edge

FROM m374crypt0/tide-alpine-docker:${BASE_STAMP} AS stage_1_packages
ARG USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
    apk add \
    --virtual .gnu-bootstrap \
    binutils=2.45.1-r1 \
    g++=15.2.0-r9 \
    gcc=15.2.0-r9 && \
    apk add \
    --virtual .llvm-dependencies \
    cmake=4.3.4-r0 \
    git=2.55.0-r1 \
    libffi-dev=3.8.0-r0 \
    linux-headers=7.2.1-r0 \
    musl-dev=1.2.6-r3 \
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

FROM clone_repository AS build_stage_1_clang_lld
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
RUN \
    cmake -G Ninja -S llvm -B llvm-build \
    -DCLANG_DEFAULT_LINKER=lld \
    -DCLANG_DEFAULT_RTLIB=compiler-rt \
    -DCLANG_ENABLE_ARCMT=OFF \
    -DCLANG_PLUGIN_SUPPORT=OFF \
    -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/home/"${USER_NAME}"/.llvm-stage-1 \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$(gcc -dumpmachine)" \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_ENABLE_ZLIB=FORCE_ON \
    -DLLVM_TARGETS_TO_BUILD="host" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF && \
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
    STAGE_2_DIR="/home/${USER_NAME}/.llvm-stage-2" && \
    TRIPLE="$(${STAGE_1_DIR}/bin/clang -print-target-triple)" && \
    CLANG_VER="$(basename "$(${STAGE_1_DIR}/bin/clang -print-resource-dir)")" && \
    cmake -G Ninja -S runtimes -B crt-build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DCMAKE_C_COMPILER="${STAGE_1_DIR}/bin/clang" \
    -DCMAKE_C_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_CXX_COMPILER="${STAGE_1_DIR}/bin/clang++" \
    -DCMAKE_INSTALL_PREFIX="${STAGE_2_DIR}" \
    -DCMAKE_LINKER="${STAGE_1_DIR}/bin/ld.lld" \
    -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
    -DCOMPILER_RT_BUILD_BUILTINS=ON \
    -DCOMPILER_RT_BUILD_CRT=ON \
    -DCOMPILER_RT_BUILD_MEMPROF=OFF \
    -DCOMPILER_RT_BUILD_PROFILE=OFF \
    -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
    -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
    -DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=OFF \
    -DCOMPILER_RT_INSTALL_PATH:PATH=lib/clang/${CLANG_VER} \
    -DCOMPILER_RT_USE_LIBCXX=ON \
    -DCOMPILER_RT_USE_LLVM_UNWINDER=OFF \
    -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
    -DLIBCXX_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_USE_COMPILER_RT=ON \
    -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
    -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TARGETS_TO_BUILD="host" && \
    cmake --build crt-build --target install
RUN \
    STAGE_2_DIR="/home/${USER_NAME}/.llvm-stage-2" && \
    TRIPLE="$(gcc -dumpmachine)" && \
    cmake -G Ninja -S llvm -B headers-build \
    -DCLANG_ENABLE_ARCMT=OFF \
    -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
    -DCLANG_PLUGIN_SUPPORT=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_CXX_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_INSTALL_PREFIX="${STAGE_2_DIR}" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
    -DLLVM_ENABLE_PROJECTS="clang" \
    -DLLVM_TARGETS_TO_BUILD="host" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF && \
    cmake --build headers-build --target install-clang-resource-headers

FROM clone_repository AS build_stage_3_runtimes
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
COPY \
    --from=build_stage_1_clang_lld --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-1 /home/${USER_NAME}/.llvm-stage-1
COPY \
    --from=build_stage_2_crt --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-2 /home/${USER_NAME}/.llvm-stage-3
RUN \
    STAGE_1_DIR="/home/${USER_NAME}/.llvm-stage-1" && \
    STAGE_3_DIR="/home/${USER_NAME}/.llvm-stage-3" && \
    TRIPLE="$(${STAGE_1_DIR}/bin/clang -print-target-triple)" && \
    CLANG_VER="$(basename "$(${STAGE_1_DIR}/bin/clang -print-resource-dir)")" && \
    cmake -G Ninja -S runtimes -B runtimes-build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DCMAKE_C_COMPILER="${STAGE_1_DIR}/bin/clang" \
    -DCMAKE_C_COMPILER_TARGET="$TRIPLE" \
    -DCMAKE_C_FLAGS="-resource-dir ${STAGE_3_DIR}/lib/clang/${CLANG_VER}" \
    -DCMAKE_CXX_COMPILER=/home/${USER_NAME}/.llvm-stage-1/bin/clang++ \
    -DCMAKE_CXX_FLAGS="-resource-dir ${STAGE_3_DIR}/lib/clang/${CLANG_VER}" \
    -DCMAKE_INSTALL_PREFIX="${STAGE_3_DIR}" \
    -DCMAKE_LINKER="${STAGE_1_DIR}/bin/ld.lld" \
    -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
    -DCOMPILER_RT_BUILD_BUILTINS=OFF \
    -DCOMPILER_RT_BUILD_CRT=OFF \
    -DCOMPILER_RT_BUILD_PROFILE=OFF \
    -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
    -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
    -DCOMPILER_RT_INSTALL_PATH:PATH="lib/clang/${CLANG_VER}" \
    -DCOMPILER_RT_USE_LIBCXX=ON \
    -DCOMPILER_RT_USE_LLVM_UNWINDER=ON \
    -DLIBCXX_HAS_ATOMIC_LIB=OFF \
    -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
    -DLIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=OFF \
    -DLIBCXX_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_USE_COMPILER_RT=ON \
    -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
    -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON \
    -DLLVM_ENABLE_RUNTIMES="libunwind;libcxxabi;libcxx" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TARGETS_TO_BUILD="host" && \
    cmake --build runtimes-build --target install

FROM clone_repository AS build_stage_4_clang_lld
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
COPY \
    --from=build_stage_1_clang_lld --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-1 /home/${USER_NAME}/.llvm-stage-1
COPY \
    --from=build_stage_3_runtimes --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-3 /home/${USER_NAME}/.llvm-stage-4
RUN \
    STAGE_1_DIR="/home/${USER_NAME}/.llvm-stage-1" && \
    STAGE_4_DIR="/home/${USER_NAME}/.llvm-stage-4" && \
    TRIPLE="$(${STAGE_1_DIR}/bin/clang -print-target-triple)" && \
    CLANG_VER="$(basename "$(${STAGE_1_DIR}/bin/clang -print-resource-dir)")" && \
    cmake -G Ninja -S llvm -B clang-lld-build \
    -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
    -DCLANG_DEFAULT_LINKER=lld \
    -DCLANG_DEFAULT_RTLIB=compiler-rt \
    -DCLANG_DEFAULT_UNWINDLIB=libunwind \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="${STAGE_1_DIR}/bin/clang" \
    -DCMAKE_C_FLAGS="-resource-dir ${STAGE_4_DIR}/lib/clang/${CLANG_VER}" \
    -DCMAKE_CXX_COMPILER="${STAGE_1_DIR}/bin/clang++" \
    -DCMAKE_CXX_FLAGS="-resource-dir ${STAGE_4_DIR}/lib/clang/${CLANG_VER} \
    -isystem ${STAGE_4_DIR}/include/${TRIPLE}/c++/v1 \
    -isystem ${STAGE_4_DIR}/include/c++/v1 \
    -L${STAGE_4_DIR}/lib/${TRIPLE} \
    -Wno-unused-command-line-argument" \
    -DCMAKE_INSTALL_PREFIX="${STAGE_4_DIR}" \
    -DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath,${STAGE_4_DIR}/lib/${TRIPLE}" \
    -DCMAKE_LINKER="${STAGE_1_DIR}/bin/ld.lld" \
    -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath,${STAGE_4_DIR}/lib/${TRIPLE}" \
    -DENABLE_LINKER_RPATH_BY_DEFAULT=ON \
    -DHAVE_CXX_ATOMICS64_WITHOUT_LIB=ON \
    -DHAVE_CXX_ATOMICS_WITHOUT_LIB=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_ENABLE_PCH=OFF \
    -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON \
    -DLLVM_ENABLE_POLLY=OFF \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_TARGETS_TO_BUILD="host" \
    -DLLVM_USE_LINKER=lld && \
    cmake --build clang-lld-build --target=install

FROM clone_repository AS build_stage_5_crt
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
COPY \
    --from=build_stage_4_clang_lld --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-4 /home/${USER_NAME}/.llvm-stage-4
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk del \
    .gnu-bootstrap
USER ${USER_NAME}
RUN \
    STAGE_4_DIR="/home/${USER_NAME}/.llvm-stage-4" && \
    STAGE_5_DIR="/home/${USER_NAME}/.llvm-stage-5" && \
    TRIPLE="$(${STAGE_4_DIR}/bin/clang -print-target-triple)" && \
    CLANG_VER="$(basename "$(${STAGE_4_DIR}/bin/clang -print-resource-dir)")" && \
    cmake -G Ninja -S runtimes -B crt-build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DCMAKE_C_COMPILER="${STAGE_4_DIR}/bin/clang" \
    -DCMAKE_C_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_CXX_COMPILER="${STAGE_4_DIR}/bin/clang++" \
    -DCMAKE_CXX_FLAGS="-isystem ${STAGE_4_DIR}/include/c++/v1 \
    -isystem ${STAGE_4_DIR}/include/${TRIPLE}/c++/v1" \
    -DCMAKE_INSTALL_PREFIX="${STAGE_5_DIR}" \
    -DCMAKE_LINKER="${STAGE_4_DIR}/bin/ld.lld" \
    -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
    -DCOMPILER_RT_BUILD_BUILTINS=ON \
    -DCOMPILER_RT_BUILD_CRT=ON \
    -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
    -DCOMPILER_RT_BUILD_MEMPROF=OFF \
    -DCOMPILER_RT_BUILD_PROFILE=OFF \
    -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
    -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
    -DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=OFF \
    -DCOMPILER_RT_INSTALL_PATH:PATH=lib/clang/${CLANG_VER} \
    -DCOMPILER_RT_USE_LIBCXX=ON \
    -DCOMPILER_RT_USE_LLVM_UNWINDER=OFF \
    -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
    -DLIBCXX_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_HAS_MUSL_LIBC=ON \
    -DLIBCXXABI_USE_COMPILER_RT=ON \
    -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
    -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TARGETS_TO_BUILD="host" && \
    cmake --build crt-build --target install
RUN \
    STAGE_4_DIR="/home/${USER_NAME}/.llvm-stage-4" && \
    STAGE_5_DIR="/home/${USER_NAME}/.llvm-stage-5" && \
    TRIPLE="$(${STAGE_4_DIR}/bin/clang -print-target-triple)" && \
    CLANG_VER="$(basename "$(${STAGE_4_DIR}/bin/clang -print-resource-dir)")" && \
    cmake -G Ninja -S llvm -B headers-build \
    -DCLANG_ENABLE_ARCMT=OFF \
    -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
    -DCLANG_PLUGIN_SUPPORT=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="${STAGE_4_DIR}/bin/clang" \
    -DCMAKE_C_FLAGS="-resource-dir ${STAGE_5_DIR}/lib/clang/${CLANG_VER} \
    -isystem ${STAGE_4_DIR}/lib/clang/${CLANG_VER}/include \
    -L${STAGE_4_DIR}/lib" \
    -DCMAKE_C_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_CXX_COMPILER="${STAGE_4_DIR}/bin/clang++" \
    -DCMAKE_CXX_FLAGS="-resource-dir ${STAGE_5_DIR}/lib/clang/${CLANG_VER} \
    -isystem ${STAGE_4_DIR}/include/c++/v1 \
    -isystem ${STAGE_4_DIR}/lib/clang/${CLANG_VER}/include \
    -L${STAGE_4_DIR}/lib \
    -Wno-unused-command-line-argument" \
    -DCMAKE_CXX_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath,${STAGE_4_DIR}/lib/${TRIPLE}" \
    -DCMAKE_INSTALL_PREFIX="${STAGE_5_DIR}" \
    -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath,${STAGE_4_DIR}/lib/${TRIPLE}" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
    -DLLVM_ENABLE_PROJECTS="clang" \
    -DLLVM_TARGETS_TO_BUILD="host" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF && \
    cmake --build headers-build --target install-clang-resource-headers

FROM clone_repository AS build_stage_6_runtimes
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
COPY \
    --from=build_stage_4_clang_lld --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-4 /home/${USER_NAME}/.llvm-stage-4
COPY \
    --from=build_stage_5_crt --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-5 /home/${USER_NAME}/.llvm
RUN \
    STAGE_4_DIR="/home/${USER_NAME}/.llvm-stage-4" && \
    STAGE_5_DIR="/home/${USER_NAME}/.llvm" && \
    STAGE_6_DIR="/home/${USER_NAME}/.llvm" && \
    TRIPLE="$(${STAGE_4_DIR}/bin/clang -print-target-triple)" && \
    CLANG_VER="$(basename "$(${STAGE_4_DIR}/bin/clang -print-resource-dir)")" && \
    cmake -G Ninja -S runtimes -B runtimes-build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DCMAKE_INSTALL_RPATH="${STAGE_6_DIR}/lib" \
    -DCMAKE_C_COMPILER="${STAGE_4_DIR}/bin/clang" \
    -DCMAKE_C_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_C_FLAGS="-resource-dir ${STAGE_5_DIR}/lib/clang/${CLANG_VER} -isystem ${STAGE_5_DIR}/lib/clang/${CLANG_VER}/include" \
    -DCMAKE_CXX_COMPILER="${STAGE_4_DIR}/bin/clang++" \
    -DCMAKE_CXX_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_CXX_FLAGS="-resource-dir ${STAGE_5_DIR}/lib/clang/${CLANG_VER} -isystem ${STAGE_5_DIR}/lib/clang/${CLANG_VER}/include" \
    -DCMAKE_INSTALL_PREFIX="${STAGE_6_DIR}" \
    -DCMAKE_LINKER="${STAGE_4_DIR}/bin/ld.lld" \
    -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
    -DCOMPILER_RT_BUILD_BUILTINS=OFF \
    -DCOMPILER_RT_BUILD_CRT=OFF \
    -DCOMPILER_RT_BUILD_SANITIZERS=ON \
    -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
    -DCOMPILER_RT_BUILD_MEMPROF=OFF \
    -DCOMPILER_RT_BUILD_ORC=OFF \
    -DCOMPILER_RT_BUILD_PROFILE=OFF \
    -DCOMPILER_RT_BUILD_XRAY=OFF \
    -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
    -DCOMPILER_RT_INSTALL_PATH:PATH=lib/clang/${CLANG_VER} \
    -DCOMPILER_RT_USE_LLVM_UNWINDER=ON \
    -DCOMPILER_RT_USE_LIBCXX=ON \
    -DLIBCXX_HAS_ATOMIC_LIB=OFF \
    -DLIBCXX_HAS_MUSL_LIBC=ON \
    -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
    -DLIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=OFF \
    -DLIBCXXABI_HAS_MUSL_LIBC=ON \
    -DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON \
    -DLIBCXXABI_USE_COMPILER_RT=ON \
    -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
    -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt;libunwind;libcxxabi;libcxx" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TARGETS_TO_BUILD="host" && \
    cmake --build runtimes-build --target install

FROM clone_repository AS build_stage_7_projects
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
COPY \
    --from=build_stage_4_clang_lld --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm-stage-4 /home/${USER_NAME}/.llvm-stage-4
COPY \
    --from=build_stage_6_runtimes --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm /home/${USER_NAME}/.llvm
RUN \
    STAGE_4_DIR="/home/${USER_NAME}/.llvm-stage-4" && \
    STAGE_6_DIR="/home/${USER_NAME}/.llvm" && \
    FINAL_DIR="/home/${USER_NAME}/.llvm" && \
    TRIPLE="$(${STAGE_4_DIR}/bin/clang -print-target-triple)" && \
    CLANG_VER="$(basename "$(${STAGE_4_DIR}/bin/clang -print-resource-dir)")" && \
    WRAP_DIR="/home/${USER_NAME}/.llvm-wrapper" && \
    mkdir -p "${WRAP_DIR}" && \
    printf '#!/bin/sh\n \
    exec %s/bin/clang \
    -ferror-limit=1 \
    -Qunused-arguments \
    -frtlib-add-rpath \
    -resource-dir %s/lib/clang/%s \
    -L%s/lib \
    -L%s/lib/%s \
    -fPIC "$@"\n' \
    "${STAGE_4_DIR}" \
    "${STAGE_6_DIR}" "${CLANG_VER}" \
    "${STAGE_6_DIR}" \
    "${STAGE_6_DIR}" "${TRIPLE}" \
    > "${WRAP_DIR}/clang" && \
    printf '#!/bin/sh\n \
    exec %s/bin/clang++ \
    -ferror-limit=1 \
    -Qunused-arguments \
    -frtlib-add-rpath \
    -nostdinc++ \
    -resource-dir %s/lib/clang/%s \
    -isystem %s/include/c++/v1 \
    -idirafter %s/include/%s/c++/v1 \
    -L%s/lib \
    -L%s/lib/%s \
    -fPIC "$@"\n' \
    "${STAGE_4_DIR}" \
    "${STAGE_6_DIR}" "${CLANG_VER}" \
    "${STAGE_6_DIR}" \
    "${STAGE_6_DIR}" "${TRIPLE}" \
    "${STAGE_6_DIR}" \
    "${STAGE_6_DIR}" "${TRIPLE}" \
    > "${WRAP_DIR}/clang++" && \
    chmod +x "${WRAP_DIR}/clang" "${WRAP_DIR}/clang++" && \
    cmake -G Ninja -S llvm -B llvm-build \
    -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
    -DCLANG_DEFAULT_LINKER=lld \
    -DCLANG_DEFAULT_RTLIB=compiler-rt \
    -DCLANG_DEFAULT_UNWINDLIB=libunwind \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_BUILD_RPATH="${STAGE_6_DIR}/lib/${TRIPLE};${STAGE_6_DIR}/lib" \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
    -DCMAKE_C_COMPILER="${WRAP_DIR}/clang" \
    -DCMAKE_C_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_CXX_COMPILER="${WRAP_DIR}/clang++" \
    -DCMAKE_CXX_COMPILER_TARGET="${TRIPLE}" \
    -DCMAKE_DISABLE_PRECOMPILE_HEADERS=ON \
    -DCMAKE_INSTALL_PREFIX="${FINAL_DIR}" \
    -DCMAKE_INSTALL_RPATH="${STAGE_6_DIR}/lib/${TRIPLE}:${STAGE_6_DIR}/lib" \
    -DCMAKE_LINKER="${STAGE_4_DIR}/bin/ld.lld" \
    -DHAVE_CXX_ATOMICS64_WITHOUT_LIB=ON \
    -DHAVE_CXX_ATOMICS_WITHOUT_LIB=ON \
    -DLLVM_BUILD_LLVM_DYLIB=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
    -DLLVM_ENABLE_EH=ON \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_ENABLE_PROJECTS="bolt;clang;clang-tools-extra;lld;lldb;mlir;polly" \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_HOST_TRIPLE="${TRIPLE}" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=ON \
    -DLLVM_INCLUDE_EXAMPLES=ON \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_PIC=ON \
    -DLLVM_TARGETS_TO_BUILD=all \
    -DLLVM_USE_LINKER=lld && \
    cmake --build llvm-build --target install

FROM m374crypt0/tide-alpine-docker:${BASE_STAMP} AS install_llvm
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
    apk add \
    zlib=1.3.2-r0 \
    zstd=1.5.7-r2
HERE

ARG USER_NAME=
USER ${USER_NAME}
COPY --chown=${USER_NAME} --from=build_stage_7_projects \
    /home/${USER_NAME}/.llvm /home/${USER_NAME}/.llvm
ENV LLVM_INSTALL_DIR=/home/${USER_NAME}/.llvm
ENV PATH="${PATH}:${LLVM_INSTALL_DIR}/bin"
WORKDIR /home/${USER_NAME}
	
FROM clone_repository AS test
ARG USER_NAME=
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/llvm-project
COPY \
    --from=build_stage_7_projects --chown=${USER_NAME} \
    /home/${USER_NAME}/.llvm /home/${USER_NAME}/.llvm
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk del gcc g++
USER ${USER_NAME}
RUN \
    LLVM_DIR="/home/${USER_NAME}/.llvm" && \
    TRIPLE="$(${LLVM_DIR}/bin/clang -print-target-triple)" && \
    cmake -G Ninja -S llvm -B clang-build \
    -DCLANG_DEFAULT_LINKER="${LLVM_DIR}/bin/lld" \
    -DCLANG_DEFAULT_RTLIB=compiler-rt \
    -DCLANG_ENABLE_ARCMT=OFF \
    -DCLANG_PLUGIN_SUPPORT=OFF \
    -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
    \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DCMAKE_INSTALL_RPATH="${LLVM_DIR}/lib/${TRIPLE}:${LLVM_DIR}/lib" \
    \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="${LLVM_DIR}/bin/clang" \
    -DCMAKE_CXX_COMPILER="${LLVM_DIR}/bin/clang++" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_ENABLE_ZLIB=FORCE_ON \
    -DLLVM_TARGETS_TO_BUILD="host" \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF && \
    cmake --build clang-build
