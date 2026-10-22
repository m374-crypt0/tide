ARG IDE_IMAGE_NAME=localhost:5000/ide

FROM ${IDE_IMAGE_NAME} AS install_bun
ARG NON_ROOT_USER_NAME=
ARG IDE_WEB_APP_BUN_VERSION=
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://bun.com/install \
    | bash -s "bun-v${IDE_WEB_APP_BUN_VERSION}"
ENV BUN_BIN_DIR="/home/${NON_ROOT_USER_NAME}/.bun/bin"
ENV PATH="${PATH}:${BUN_BIN_DIR}"
RUN bun install -g \
		typescript@7.0.2 \
		typescript-language-server@6.0.2 \
		@astrojs/language-server@2.17.2 \
		vscode-langservers-extracted@4.10.0 \
		@tailwindcss/language-server@0.16.0 \
		@biomejs/biome@2.5.15 \
		eslint@10.13.0 \
		prettier@3.9.10
