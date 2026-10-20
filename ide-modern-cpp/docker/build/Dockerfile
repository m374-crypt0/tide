ARG IDE_IMAGE_NAME=localhost:5000/tide-ide

FROM ${IDE_IMAGE_NAME} AS install_cmake
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
	--mount=type=cache,target=/var/cache/apk,sharing=locked \
		apk add \
		ccmake=4.3.4-r0 \
		cmake=4.3.4-r0 \
		cmake-bash-completion=4.3.4-r0 \
		cmake-doc=4.3.4-r0
USER ${NON_ROOT_USER_NAME}
