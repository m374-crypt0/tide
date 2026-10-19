ARG IDE_IMAGE_NAME=localhost:5000/ide

FROM ${IDE_IMAGE_NAME} AS install_bun
ARG NON_ROOT_USER_NAME=
ARG IDE_WEB_APP_BUN_VERSION=
USER ${NON_ROOT_USER_NAME}
WORKDIR "/home/${NON_ROOT_USER_NAME}"
RUN curl -fsSL https://bun.com/install \
    | bash -s "bun-v${IDE_WEB_APP_BUN_VERSION}"
