stamp=$(date -u +%4Y%m%d%H%M%S)

docker build \
  -f contexts/tide-alpine-pinned/Dockerfile \
  -t m374crypt0/tide-alpine-pinned:edge \
  -t m374crypt0/tide-alpine-pinned:"$stamp" \
  --label IMAGE_KIND=tide \
  --label IMAGE_STAMP="$stamp" \
  ./contexts/tide-alpine-pinned
