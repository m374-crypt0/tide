ARG IDE_IMAGE_NAME=localhost:5000/tide-ide

FROM ${IDE_IMAGE_NAME} AS install_cmake_packages
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
	--mount=type=cache,target=/var/cache/apk,sharing=locked \
		apk add \
		ccmake=4.3.4-r0 \
		cmake=4.3.4-r0 \
		cmake-bash-completion=4.3.4-r0 \
		neocmakelsp=0.11.2-r0 \
		neocmakelsp-bash-completion=0.11.2-r0 \
		samurai=1.3-r0 \
		cmake-doc=4.3.4-r0 \
		neocmakelsp-doc=0.11.2-r0 \
		samurai-doc=1.3-r0
USER ${NON_ROOT_USER_NAME}

FROM install_cmake_packages AS install_cmake_lint
ARG NON_ROOT_USER_NAME=
USER ${NON_ROOT_USER_NAME}
RUN pip3 install --no-cache-dir cmakelint==1.4.3
