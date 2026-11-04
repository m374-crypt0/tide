ARG NON_ROOT_USER_IMAGE_NAME=localhost:5000/tide-non-root-user
ARG LLVM_IMAGE_NAME=localhost:5000/tide-llvm

FROM ${LLVM_IMAGE_NAME} AS llvm

FROM ${NON_ROOT_USER_IMAGE_NAME} AS install_llvm
ARG NON_ROOT_USER_NAME=
ARG LLVM_OUTPUT_RESOURCE_DIR=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
    musl-dev=1.2.6-r6 \
    zlib=1.3.2-r1 \
    zstd=1.5.7-r2
USER ${NON_ROOT_USER_NAME}
COPY --chown=${NON_ROOT_USER_NAME} --from=llvm \
    ${LLVM_OUTPUT_RESOURCE_DIR} ${LLVM_OUTPUT_RESOURCE_DIR}
ENV LLVM_OUTPUT_RESOURCE_DIR="${LLVM_OUTPUT_RESOURCE_DIR}"
ENV PATH="${PATH}:${LLVM_OUTPUT_RESOURCE_DIR}/bin"

FROM install_llvm AS install_build_dependencies
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
    git=2.56.0-r0 \
    cmake=4.3.4-r0 \
    make=4.4.1-r4 \
    pkgconf=3.0.10-r0 \
    libssl3=3.5.9-r0 \
    vulkan-loader-dev=1.4.360-r0 \
    shaderc=2026.1-r0 \
    glslang=1.4.341.0-r0 \
    spirv-headers=1.4.357.0-r0 \
    npm=12.0.2-r0 \
    linux-headers=7.2.1-r0 \
    ffmpeg-dev=9.0.2-r1
USER ${NON_ROOT_USER_NAME}

FROM install_build_dependencies AS clone_repository
ARG NON_ROOT_USER_NAME=
ARG ADVG_WHISPER_CPP_REVISION=
WORKDIR "/home/${NON_ROOT_USER_NAME}"
RUN git clone \
    --depth 1 \
    --rev=${ADVG_WHISPER_CPP_REVISION} \
    https://github.com/ggml-org/whisper.cpp.git whisper.cpp
WORKDIR "/home/${NON_ROOT_USER_NAME}/whisper.cpp"

FROM clone_repository AS patch_repository
ARG NON_ROOT_USER_NAME=
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}/whisper.cpp/"
COPY \
    --chown=${NON_ROOT_USER_NAME} \
    tide.patch "/home/${NON_ROOT_USER_NAME}/whisper.cpp"
RUN git apply "/home/${NON_ROOT_USER_NAME}/whisper.cpp/tide.patch"

FROM patch_repository AS configure_whisper_cpp
ARG NON_ROOT_USER_NAME=
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}/whisper.cpp/"
RUN cmake -B build \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_CXX_FLAGS="-stdlib=libc++ -nostdlib++" \
    -DCMAKE_CXX_IMPLICIT_LINK_LIBRARIES="" \
    -DCMAKE_CXX_STANDARD_LIBRARIES="" \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DGGML_OPENMP=OFF \
    -DGGML_RVV=OFF \
    -DGGML_STATIC=ON \
    -DGGML_VULKAN=ON \
    -DWHISPER_BUILD_IS_DEV=OFF \
    -DWHISPER_BUILD_SERVER=ON \
    -DWHISPER_COMMON_FFMPEG=ON

FROM configure_whisper_cpp AS build_whisper_cpp
ARG NON_ROOT_USER_NAME=
USER ${NON_ROOT_USER_NAME}
RUN \
    cmake --build build -j "$(nproc)" --target \
    whisper-cli whisper-server whisper-bench

FROM ${NON_ROOT_USER_IMAGE_NAME} AS install_whisper_cpp
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
    vulkan-loader=1.4.360-r0 \
    vulkan-tools=1.4.360-r0 \
    mesa-vulkan-ati=26.2.6-r0 \
    mesa-dri-gallium=26.2.6-r0 \
    ffmpeg-dev=9.0.2-r1
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}"
RUN mkdir -p "/home/${NON_ROOT_USER_NAME}/.local/.whisper.cpp/bin"
COPY --chown=${NON_ROOT_USER_NAME} --from=build_whisper_cpp \
    "/home/${NON_ROOT_USER_NAME}/whisper.cpp/build/bin/whisper-cli" \
    "/home/${NON_ROOT_USER_NAME}/whisper.cpp/build/bin/whisper-server" \
    "/home/${NON_ROOT_USER_NAME}/whisper.cpp/build/bin/whisper-bench" \
    "/home/${NON_ROOT_USER_NAME}/.local/.whisper.cpp/bin"/
ENV WHISPER_CPP_BIN_DIR="/home/${NON_ROOT_USER_NAME}/.local/.whisper.cpp/bin"
ENV PATH="${PATH}:$WHISPER_CPP_BIN_DIR"

FROM install_whisper_cpp AS install_huggingface_cli
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
    curl=8.23.0-r0 \
    python3=3.14.10-r1
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -LsSf https://hf.co/cli/install.sh | bash -s -- --no-modify-path
ENV PATH="${PATH}:/home/${NON_ROOT_USER_NAME}/.local/bin"

FROM install_huggingface_cli AS setup_groups
ARG NON_ROOT_USER_NAME=
ARG ADVG_RENDER_GROUP_ID=
ARG ADVG_VIDEO_GROUP_ID=
# hadolint ignore=DL3066
USER root
RUN groupadd -fg "${ADVG_RENDER_GROUP_ID}" render \
    && groupmod -g "${ADVG_VIDEO_GROUP_ID}" video
USER ${NON_ROOT_USER_NAME}

FROM install_huggingface_cli AS install_supported_model_scripts
ARG NON_ROOT_USER_NAME=
WORKDIR "/home/${NON_ROOT_USER_NAME}"
RUN mkdir -p \
    "decoding-setup/xkeyC/whisper-large-v3-turbo-gguf/model_q4_1.gguf"
WORKDIR "/home/${NON_ROOT_USER_NAME}/decoding-setup"
COPY --chown=${NON_ROOT_USER_NAME} \
    "./model-run-scripts/xkeyC/whisper-large-v3-turbo-gguf/model_q4_1.gguf/run.bash" \
    "xkeyC/whisper-large-v3-turbo-gguf/model_q4_1.gguf/"
RUN find . -type f -name run.bash -exec chmod +x {} \;
