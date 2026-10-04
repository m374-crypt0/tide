base_stamp=edge
this_stamp=$(date -u +%4Y%m%d%H%M%S)
llvm_commit=69212dda8d0ebdcecd3f2ff034e1ae553f4ac9db

docker build \
  --target install_llvm \
  -f contexts/tide-alpine-llvm/Dockerfile \
  --build-arg BASE_STAMP=$base_stamp \
  --build-arg LLVM_COMMIT="$llvm_commit" \
  --build-arg USER_NAME="$(id -nu)" \
  -t m374crypt0/tide-alpine-llvm:edge \
  -t m374crypt0/tide-alpine-llvm:"$this_stamp" \
  ./contexts/tide-alpine-llvm
