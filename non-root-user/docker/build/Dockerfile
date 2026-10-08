ARG ALPINE_PINNED_IMAGE_NAME=localhost:5000/tide-alpine-pinned

FROM ${ALPINE_PINNED_IMAGE_NAME} AS install_packages
RUN \
		--mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
		shadow=4.20.3-r2 \
    su-exec=0.3-r0 \
    sudo=1.9.17_p2-r3 \
    shadow-doc=4.20.3-r2 \
    sudo-doc=1.9.17_p2-r3

FROM install_packages AS configure_user
ARG NON_ROOT_USER_GID=
ARG NON_ROOT_USER_NAME=
ARG NON_ROOT_USER_UID=
RUN \
		groupadd -g "${NON_ROOT_USER_GID}" "${NON_ROOT_USER_NAME}" && \
		useradd \
		-d "/home/${NON_ROOT_USER_NAME}" \
		-u "${NON_ROOT_USER_UID}" \
		-g "${NON_ROOT_USER_GID}" \
		-m \
		-s /bin/bash \
		-l "${NON_ROOT_USER_NAME}" && \
		echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" \
		> "/etc/sudoers.d/${NON_ROOT_USER_NAME}"
USER ${NON_ROOT_USER_NAME}
WORKDIR /home/${NON_ROOT_USER_NAME}}
