base_stamp=edge
this_stamp=$(date -u +%4Y%m%d%H%M%S)
llvm_commit=06b71c9085beffd088f8e6e8b8da79b452acb786

docker build \
  -f contexts/tide-alpine-llvm/Dockerfile \
  --build-arg BASE_STAMP=$base_stamp \
  --build-arg LLVM_COMMIT="$llvm_commit" \
  --build-arg USER_NAME="$(id -nu)" \
  -t m374crypt0/tide-alpine-llvm:edge \
  -t m374crypt0/tide-alpine-llvm:"$this_stamp" \
  ./contexts/tide-alpine-llvm
