FROM alpine:edge AS pinned_world
# NOTE: pinned basic packages in world. Any update will break the build, it is
# intentional
COPY world /etc/apk/world
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk fix -U && \
    apk add \
    apk-tools=3.0.8-r0 \
    busybox=1.38.0-r7 \
    busybox-binsh=1.38.0-r7 \
    ca-certificates-bundle=20260909-r0 \
    libapk=3.0.8-r0 \
    libcrypto3=3.5.9-r0 \
    libssl3=3.5.9-r0 \
    musl=1.2.6-r4 \
    musl-utils=1.2.6-r4 \
    ssl_client=1.38.0-r7 &&\
    apk add \
    bash=5.3.9-r2 \
    man-db=2.13.1-r1 \
    shadow=4.20.3-r1 \
    su-exec=0.3-r0 \
    sudo=1.9.17_p2-r2 \
    apk-tools-doc=3.0.8-r0 \
    busybox-doc=1.38.0-r7 \
    man-db-doc=2.13.1-r1 \
    shadow-doc=4.20.3-r1 \
    sudo-doc=1.9.17_p2-r2
