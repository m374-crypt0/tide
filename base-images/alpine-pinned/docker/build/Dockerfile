FROM alpine:edge AS pinned_world
# NOTE: pinned basic packages in world. Any update will break the build, it is
# intentional
COPY world /etc/apk/world
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk fix -U

FROM pinned_world AS install_packages
RUN \
		--mount=type=cache,target=/var/cache/apk,sharing=locked \
		apk add \
    bash=5.3.9-r2 \
		busybox=1.38.0-r8

FROM install_packages AS install_doc
RUN \
		--mount=type=cache,target=/var/cache/apk,sharing=locked \
		apk add \
    bash-doc=5.3.9-r2 \
		busybox-doc=1.38.0-r8 \
    man-db=2.13.1-r1 \
    man-db-doc=2.13.1-r1
