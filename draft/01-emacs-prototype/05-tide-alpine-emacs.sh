base_stamp=edge
this_stamp=$(date -u +%4Y%m%d%H%M%S)
emacs_commit=8899f65f39219410d8b3eb84611071e48348e8bf

docker build \
  -f contexts/tide-alpine-emacs/Dockerfile \
  --build-arg BASE_STAMP=$base_stamp \
  --build-arg EMACS_COMMIT="$emacs_commit" \
  --build-arg USER_NAME="$(id -nu)" \
  -t m374crypt0/tide-alpine-emacs:edge \
  -t m374crypt0/tide-alpine-emacs:"$this_stamp" \
  ./contexts/tide-alpine-emacs
