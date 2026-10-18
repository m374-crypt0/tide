ARG DOCKER_IN_DOCKER_IMAGE_NAME=localhost:5000/tide-docker-in-docker
ARG EMACS_IMAGE_NAME=localhost:5000/tide-emacs

FROM ${EMACS_IMAGE_NAME} AS emacs

FROM ${DOCKER_IN_DOCKER_IMAGE_NAME} AS install_emacs
ARG NON_ROOT_USER_NAME=
ARG EMACS_OUTPUT_RESOURCE_DIR=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
    libncursesw=6.6_p20260822-r0 \
		libxml2-dev=2.13.9-r2 \
    ncurses-terminfo-base=6.6_p20260822-r0 \
    tree-sitter=0.26.7-r1
USER ${NON_ROOT_USER_NAME}
COPY --chown=${NON_ROOT_USER_NAME} --from=emacs \
		${EMACS_OUTPUT_RESOURCE_DIR} ${EMACS_OUTPUT_RESOURCE_DIR}
ENV EMACS_OUTPUT_RESOURCE_DIR="${EMACS_OUTPUT_RESOURCE_DIR}"
ENV PATH="${PATH}:${EMACS_OUTPUT_RESOURCE_DIR}/bin"

FROM install_emacs AS install_distribution_packages
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
		bc=1.08.2-r1 \
		btop=1.4.7-r0 \
		coreutils=9.11-r2 \
		coreutils-env=9.11-r2 \
		coreutils-fmt=9.11-r2 \
		curl=8.22.0-r0 \
		findutils=4.11.0-r2 \
		findutils-locate=4.11.0-r2 \
		git=2.56.0-r0 \
		gnutls-utils=3.8.13-r0 \
		gzip=1.15-r0 \
		inotify-tools=4.25.9.0-r0 \
		less=710-r0 \
		make=4.4.1-r4 \
		musl-locales=0.1.0-r1 \
		musl-locales-lang=0.1.0-r1 \
		openssh-client-default=10.6_p1-r1 \
		procps-ng=4.0.7-r2 \
		ripgrep=15.2.0-r0 \
		strace=7.2-r0 \
		tar=1.35-r5 \
		texinfo=7.3-r1 \
		tmux=3.8-r0 \
		unzip=6.0-r16 \
		wget=1.25.0-r3 \
		bc-doc=1.08.2-r1 \
		btop-doc=1.4.7-r0 \
		coreutils-doc=9.11-r2 \
		curl-doc=8.22.0-r0 \
		findutils-doc=4.11.0-r2 \
		findutils-locate-doc=4.11.0-r2 \
		git-doc=2.56.0-r0 \
		gnutls-doc=3.8.13-r0 \
		gzip-doc=1.15-r0 \
		inotify-tools-doc=4.25.9.0-r0 \
		less-doc=710-r0 \
		make-doc=4.4.1-r4 \
		openssh-doc=10.6_p1-r1 \
		procps-ng-doc=4.0.7-r2 \
		ripgrep-doc=15.2.0-r0 \
		strace-doc=7.2-r0 \
		tar-doc=1.35-r5 \
		texinfo-doc=7.3-r1 \
		tmux-doc=3.8-r0 \
		unzip-doc=6.0-r16 \
		wget-doc=1.25.0-r3
USER ${NON_ROOT_USER_NAME}

FROM install_distribution_packages AS install_utility_packages
ARG NON_ROOT_USER_NAME=
# hadolint ignore=DL3066
USER root
RUN \
    --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add \
		jq=1.8.2-r0 \
		nodejs-current=26.11.1-r0 \
		npm=12.0.2-r0 \
		npm-bash-completion=12.0.2-r0 \
		shellcheck=0.11.0-r2 \
		jq-doc=1.8.2-r0 \
		nodejs-current-doc=26.11.1-r0 \
		npm-doc=12.0.2-r0 \
		shellcheck-doc=0.11.0-r2
USER ${NON_ROOT_USER_NAME}

FROM install_utility_packages AS configure_npm
ARG NON_ROOT_USER_NAME=
USER ${NON_ROOT_USER_NAME}
RUN npm config edit \
		--editor /bin/true && \
		echo "prefix=/home/${NON_ROOT_USER_NAME}/.npm" \
		>> "/home/${NON_ROOT_USER_NAME}/.npmrc" && \
		npm install -g \
		bash-language-server@5.8.1 \
		dockerfile-language-server-nodejs@0.15.0 \
		markdownlint-lsp@0.10.0 
	ENV NPM_BIN_PATH="/home/${NON_ROOT_USER_NAME}/.npm/bin"
ENV PATH="${PATH}:${NPM_BIN_PATH}"

FROM configure_npm AS install_interactive_tooling
ARG NON_ROOT_USER_NAME=
USER ${NON_ROOT_USER_NAME}
WORKDIR /home/${NON_ROOT_USER_NAME}
RUN git clone --depth=1 \
		https://github.com/Bash-it/bash-it.git \
		"/home/${NON_ROOT_USER_NAME}/.bash_it" && \
		".bash_it/install.sh" -s

FROM install_interactive_tooling AS install_minimal_emacs_d
ARG NON_ROOT_USER_NAME=
ARG IDE_MINIMAL_EMACS_REVISION=
USER ${NON_ROOT_USER_NAME}
WORKDIR /home/${NON_ROOT_USER_NAME}
RUN git clone \
		--depth=1 --rev="${IDE_MINIMAL_EMACS_REVISION}" \
		https://github.com/jamescherti/minimal-emacs.d ~/.emacs.d
COPY --chown=${NON_ROOT_USER_NAME} \
		emacs/pre-early-init.el \
		emacs/post-early-init.el \
		emacs/pre-init.el \
		emacs/post-init.el \
		"/home/${NON_ROOT_USER_NAME}/.emacs.d"/
