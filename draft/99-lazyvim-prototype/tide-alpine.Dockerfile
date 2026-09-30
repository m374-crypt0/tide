FROM alpine:edge AS pinned_world
# NOTE: pinned basic packages in world. Any update will break the build, it is
# intentional
COPY world /etc/apk/world
RUN \
  --mount=type=cache,target=/var/cache/apk,sharing=locked <<HERE
  apk fix -U
  apk add \
  bash=5.3.9-r1 \
  shadow=4.18.0-r1 \
  su-exec=0.3-r0 \
  sudo=1.9.17_p2-r1 \
  sudo-doc=1.9.17_p2-r1
HERE
