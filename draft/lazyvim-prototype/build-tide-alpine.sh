stamp=$(date -u +%+4Y%m%d%H%M%S)

docker build \
  -f tide-alpine.Dockerfile \
  -t m374crypt0/tide-alpine:edge \
  -t m374crypt0/tide-alpine:"$stamp" \
  .
