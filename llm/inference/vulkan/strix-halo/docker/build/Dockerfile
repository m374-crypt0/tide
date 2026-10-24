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
		linux-headers=7.2.1-r0
USER ${NON_ROOT_USER_NAME}

FROM install_build_dependencies AS clone_repository
ARG NON_ROOT_USER_NAME=
ARG STRIX_HALO_ROCMPFX_REVISION=
WORKDIR "/home/${NON_ROOT_USER_NAME}"
RUN git clone \
		--depth 1 \
		--rev=${STRIX_HALO_ROCMPFX_REVISION} \
		https://github.com/charlie12345/ROCmFPX.git ROCmFPX
WORKDIR "/home/${NON_ROOT_USER_NAME}/ROCmFPX"

FROM clone_repository AS configure_rocmfpx
ARG NON_ROOT_USER_NAME=
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}/ROCmFPX/"
RUN cmake -B build \
		-DBUILD_SHARED_LIBS=OFF \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_C_COMPILER=clang \
		-DCMAKE_CXX_COMPILER=clang++ \
		-DCMAKE_CXX_FLAGS="-stdlib=libc++ -nostdlib++" \
		-DCMAKE_CXX_STANDARD_LIBRARIES="" \
		-DCMAKE_CXX_IMPLICIT_LINK_LIBRARIES="" \
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
		-DGGML_BUILD_TESTS=OFF \
		-DGGML_VULKAN=ON \
		-DLLAMA_BUILD_SERVER=ON \
		-DLLAMA_BUILD_TESTS=OFF \
		-DLLAMA_BUILD_WEBUI=ON \
		-DLLAMA_USE_PREBUILT_WEBUI=OFF

FROM configure_rocmfpx AS patch_rocmfpx
ARG NON_ROOT_USER_NAME=
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}/ROCmFPX/"
COPY \
		--chown=${NON_ROOT_USER_NAME} \
		tide.patch "/home/${NON_ROOT_USER_NAME}/ROCmFPX"
RUN git apply "/home/${NON_ROOT_USER_NAME}/ROCmFPX/tide.patch"

FROM patch_rocmfpx AS build_rocmfpx
ARG NON_ROOT_USER_NAME=
USER ${NON_ROOT_USER_NAME}
RUN \
	  cmake --build build -j "$(nproc)" --target \
		llama-cli \
		llama-server

FROM ${NON_ROOT_USER_IMAGE_NAME} as install_rcmfpx
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
		--mount=type=cache,target=/var/cache/apk,sharing=locked \
		apk add \
		vulkan-loader=1.4.360-r0
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}"
RUN mkdir -p "/home/${NON_ROOT_USER_NAME}/.local/.ROCmFPX/bin"
COPY --chown=${NON_ROOT_USER_NAME} --from=build_rocmfpx \
		"/home/${NON_ROOT_USER_NAME}/ROCmFPX/build/bin/llama-cli" \
		"/home/${NON_ROOT_USER_NAME}/ROCmFPX/build/bin/llama-server" \
		"/home/${NON_ROOT_USER_NAME}/.local/.ROCmFPX/bin"/
ENV ROCMFPX_BIN_DIR="/home/${NON_ROOT_USER_NAME}/.local/.ROCmFPX/bin"
ENV PATH="${PATH}:$ROCMFPX_BIN_DIR"
