# tide-alpine-llvm — GNU-free LLVM toolchain

Documentation of the multi-stage build. Every CMake option is explained in terms
of the constraint it addresses.

---

## 1. Purpose

Produce a self-contained LLVM toolchain — clang, lld, lldb, the clang tools,
MLIR, BOLT, Polly — installed into a fixed prefix under the
`${REGISTRY_HOST}:${REGISTRY_PORT}/${LLVM_IMAGE_NAME}` base image. The toolchain
must:

- contain **no GNU components** (no libstdc++, no libgcc_s, no GCC at runtime);
- be built **from a pinned LLVM commit** for reproducibility;
- run inside Alpine/musl, dynamically linking only to musl and to LLVM's own
  runtimes (libc++, libc++abi, libunwind, compiler-rt);
- be able to produce **fully static executables** that run on any modern Linux
  distribution, including glibc-based ones.

## 2. Design constraints

| Constraint | Consequence |
| --- | --- |
| No GNU components in the final toolchain | GCC is used only as a bootstrap compiler forc stage 1, then removed before the final toolchain is built. |
| No `LLVM_ENABLE_RUNTIMES` bootstrap mode | The bootstrap is orchestrated by hand with Docker stages. LLVM's own nested-CMake bootstrap is not used. |
| Pinned LLVM commit | `--rev=${LLVM_REVISION}` on the clone; all CMake variables are set explicitly rather than relying on defaults that change between revisions. |
| Single host architecture for the bootstrap, all targets for the final toolchain | `LLVM_TARGETS_TO_BUILD=host` in stages 1–6; `=all` in stage 7. |
| Reproducible runtime layout | `LLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON` everywhere; `COMPILER_RT_INSTALL_PATH:PATH=lib/clang/<ver>` in the standalone runtimes stages. |
| No flang | `LLVM_ENABLE_PROJECTS` never includes `flang`. |

## 3. Building the image

```yaml
name: tide

services:
  llvm:
    build:
      args:
        NON_ROOT_USER_IMAGE_NAME: ${REGISTRY_HOST}:${REGISTRY_PORT}/${NON_ROOT_USER_IMAGE_NAME}
        NON_ROOT_USER_NAME: ${NON_ROOT_USER_NAME}
        LLVM_REVISION: ${LLVM_REVISION}
        LLVM_OUTPUT_RESOURCE_DIR: ${LLVM_OUTPUT_RESOURCE_DIR}
      context: build/context
      dockerfile: ../Dockerfile
      tags:
        - ${REGISTRY_HOST}:${REGISTRY_PORT}/${LLVM_IMAGE_NAME}
    environment:
      - LLVM_OUTPUT_RESOURCE_DIR
    image: ${REGISTRY_HOST}:${REGISTRY_PORT}/${LLVM_IMAGE_NAME}
```

The `test` stage is built thanks to a clever trick (`RUN --mount=type=bind...`)
to ensure the toolchain is functional.
`NON_ROOT_USER_NAME` is taken from the invoking user so that the build prefix
(`${LLVM_OUTPUT_RESOURCE_DIR}`) matches the image's runtime
layout. `LLVM_REVISION` pins the exact revision.

## 4. Pipeline overview

| Stage | Purpose | Compiler used | Throwaway? |
| --- | --- | --- | --- |
| `stage_1_packages` | install GNU bootstrap toolchain + LLVM build deps | — | yes |
| `clone_repository` | shallow clone at `LLVM_COMMIT` | — | shared |
| `build_stage_1_clang_lld` | bootstrap clang + lld (GNU-linked) | Alpine GCC 15.2 | yes |
| `build_stage_2_crt` | compiler-rt crt objects + builtins + clang resource headers | stage 1 clang | yes |
| `build_stage_3_runtimes` | libunwind + libc++abi + libc++ for stage 4 | stage 1 clang | yes |
| `build_stage_4_clang_lld` | **GNU-free clang + lld** | stage 1 clang, linked against stage 3 | no |
| `build_stage_5_crt` | crt + builtins + resource headers for the final toolchain | stage 4 clang | no |
| `build_stage_6_runtimes` | sanitizers + libunwind + libc++abi + libc++ for the final toolchain | stage 4 clang | no |
| `build_stage_7_projects` | **final toolchain**: bolt, clang, clang-tools-extra, lld, lldb, mlir, polly | stage 4 clang, linked against stage 6 | no |
| `test` | rebuild clang with the new toolchain in a GCC-free image | stage 7 clang | verification |
| `install_llvm` | runtime image: final prefix + PATH | — | shipped |

The pipeline has two phases. Stages 1–4 produce a **GNU-free bootstrap
compiler**. Stages 5–7 use that compiler to produce the **final toolchain**,
which is identical in structure but includes sanitizers, all backends, and all
projects.

## 5. Stage-by-stage

### 5.1 `stage_1_packages`

Two virtual packages are installed:

- **`.gnu-bootstrap`** — `binutils`, `gcc`, `g++`. Used to compile the bootstrap
  clang in stage 1. Removed after stage 4 with `apk del .gnu-bootstrap`.
- **`.llvm-dependencies`** — `cmake`, `git`, `libffi-dev`, `linux-headers`,
  `musl-dev`, `python3`, `samurai`, `zlib-dev`, `zstd-dev`. Kept for the entire
  build.

`musl-dev` is installed **explicitly**, not as a transitive dependency of
`gcc`. Alpine's `gcc` does not depend on `musl-dev`, and `apk del gcc g++` would
leave `dlfcn.h`, `stdio.h`, and the rest of musl's headers unreachable. Putting
`musl-dev` in the world file protects it from removal.

### 5.2 `clone_repository`

Shallow clone at `LLVM_REVISION`. The pinned SHA is the only reproducibility
anchor; every CMake variable below is set explicitly because LLVM's defaults
drift between revisions.

### 5.3 `build_stage_1_clang_lld`

Bootstrap clang + lld, built with Alpine GCC, installed into `.llvm-stage-1`.

| Option | Reason |
| --- | --- |
| `-DCLANG_DEFAULT_LINKER=lld` | bake lld as the driver's default linker, so downstream invocations use it without `-fuse-ld`. |
| `-DCLANG_DEFAULT_RTLIB=compiler-rt` | bake compiler-rt as the default runtime library. |
| `-DCLANG_ENABLE_ARCMT=OFF` | ARC migration tool is deprecated and unused. |
| `-DCLANG_PLUGIN_SUPPORT=OFF` | no plugin ABI needed; saves build time. |
| `-DCLANG_ENABLE_STATIC_ANALYZER=OFF` | static analyzer is unused in the pipeline. |
| `-DCMAKE_BUILD_TYPE=Release` | toolchain must be fast; debug info not needed. |
| `-DLLVM_DEFAULT_TARGET_TRIPLE="$(gcc -dumpmachine)"` | `x86_64-alpine-linux-musl`. Same value is reused in every subsequent stage; consistency is critical. |
| `-DLLVM_ENABLE_PROJECTS="clang;lld"` | only the two projects needed for bootstrap. |
| `-DLLVM_ENABLE_ZLIB=FORCE_ON` | required for compressed debug sections and for linking against zlib in downstream tools. |
| `-DLLVM_TARGETS_TO_BUILD="host"` | bootstrap compiler only needs to emit code for the host. |
| `-DLLVM_INCLUDE_{BENCHMARKS,DOCS,EXAMPLES,TESTS}=OFF` | nothing in the toolchain needs them; each is minutes saved. |
| *(no `LLVM_ENABLE_RUNTIMES`)* | deliberate. Stage 1 clang has an **empty resource directory**. It is only used as a compiler, never as a target for its own runtimes. |
| `-DLLVM_ENABLE_POLLY` *(absent)* | Polly is not in `LLVM_ENABLE_PROJECTS` here. |

### 5.4 `build_stage_2_crt`

Builds `compiler-rt`'s crt objects, builtins, and clang resource headers into
`.llvm-stage-2`, using stage 1 clang.

| Option | Reason |
| --- | --- |
| `-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON` | the Ninja generator refuses to install targets that would need their RPATH rewritten. Since these are throwaway artifacts, baking the install RPATH from the start avoids the refusal. |
| `-DCMAKE_C_COMPILER_TARGET="${TRIPLE}"` / `-DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}"` | both must be the same triple for the runtimes build to place files correctly. |
| `-DCMAKE_LINKER="${STAGE_1_DIR}/bin/ld.lld"` | use lld, not the GNU linker that Alpine ships. |
| `-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY` | during crt build, link-based compile checks would fail because compiler-rt builtins are not yet installed. Compiling to object files instead bypasses the link step. |
| `-DCOMPILER_RT_BUILD_BUILTINS=ON`, `CRT=ON` | the two artifacts that must exist before anything else can be linked. |
| `-DCOMPILER_RT_BUILD_MEMPROF=OFF`, `PROFILE=OFF`, `SANITIZERS=OFF` | bootstrap does not need them; deferred to stage 6. |
| `-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON` | **mandatory.** Without it, compiler-rt tries to build for the default multilib set, which on `x86_64-alpine-linux-musl` includes i386 and fails with `-m32` errors. |
| `-DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=OFF` | keep the atomic builtins; they are needed for 64-bit atomics. |
| `-DCOMPILER_RT_INSTALL_PATH:PATH=lib/clang/${CLANG_VER}` | **mandatory in a standalone `-S runtimes` build.** `CLANG_RESOURCE_DIR` is not consulted outside an in-tree project build; `COMPILER_RT_INSTALL_PATH` is the supported knob. Without it, builtins land at `lib/${TRIPLE}/` and clang's driver never finds them. |
| `-DCOMPILER_RT_USE_LIBCXX=ON` | use libc++ rather than libstdc++. |
| `-DCOMPILER_RT_USE_LLVM_UNWINDER=OFF` | libunwind does not exist yet at this stage. |
| `-DLIBCXX_HAS_MUSL_LIBC=ON` / `-DLIBCXXABI_HAS_MUSL_LIBC=ON` | **mandatory** on musl. Without them the headers configure for a glibc-shaped runtime. |
| `-DLIBCXXABI_USE_COMPILER_RT=ON` | the ABI library must use the just-built compiler-rt, not libgcc. |
| `-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON` | **mandatory.** Without it, `compiler-rt` installs under `lib/linux/` and clang's per-target lookup fails. |
| `-DLLVM_ENABLE_RUNTIMES="compiler-rt"` | build only the crt components now. |

The second `RUN` in the same stage builds **only the clang resource headers**
with `install-clang-resource-headers`. It uses `LLVM_ENABLE_PROJECTS="clang"`
because the target lives in the clang project, but builds only that one target.

### 5.5 `build_stage_3_runtimes`

Builds libunwind, libc++abi, libc++ into `.llvm-stage-3`, using stage 1
clang. This tree is what stage 4 clang will link against.

| Option | Reason |
| --- | --- |
| `-DCOMPILER_RT_BUILD_BUILTINS=OFF`, `CRT=OFF` | already built in stage 2, copied in. Only the C++ runtime stack is built here. |
| `-DCOMPILER_RT_INSTALL_PATH:PATH=lib/clang/${CLANG_VER}` | keep the compiler-rt installation path consistent even though nothing is being installed there in this stage. |
| `-DCOMPILER_RT_USE_LLVM_UNWINDER=ON` | libunwind is being built in the same invocation, so compiler-rt can reference it. |
| `-DLIBCXX_HAS_ATOMIC_LIB=OFF` | musl has no separate `libatomic`; atomics come from compiler-rt builtins. |
| `-DLIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=OFF` | **mandatory on musl.** musl does not provide `__cxa_thread_atexit_impl`; leaving this ON produces an undefined symbol at link time. |
| `-DCMAKE_C_FLAGS` / `-DCMAKE_CXX_FLAGS` = `-resource-dir ${STAGE_3_DIR}/lib/clang/${CLANG_VER}` | stage 1 clang's resource dir is empty; this points it at the crt objects copied from stage 2. |
| `-DLLVM_ENABLE_RUNTIMES="libunwind;libcxxabi;libcxx"` | explicit order: libunwind first, then libc++abi which uses it, then libc++ which uses both. |

### 5.6 `build_stage_4_clang_lld`

**The pivotal stage.** Rebuilds clang + lld, this time linked against stage 3's
libc++/libc++abi/libunwind, producing the first GNU-free compiler.

| Option | Reason |
| --- | --- |
| `-DCLANG_DEFAULT_CXX_STDLIB=libc++` | bake libc++ as the default. This is what lets Stage 7's `clang++` produce C++ binaries without the user passing `-stdlib=libc++`. |
| `-DCLANG_DEFAULT_LINKER=lld`, `RTLIB=compiler-rt`, `UNWINDLIB=libunwind` | same reasoning for the linker, runtime library, and unwinder. The combination is what makes the shipped toolchain GNU-free by default. |
| `-DCMAKE_C_FLAGS` / `CXX_FLAGS` = `-resource-dir ${STAGE_4_DIR}/lib/clang/${CLANG_VER}` | points stage 1 clang at stage 4's tree (which holds the copied stage 3 artifacts) for compilation. |
| `-DCMAKE_CXX_FLAGS` = `... -isystem ${STAGE_4_DIR}/include/${TRIPLE}/c++/v1 -isystem ${STAGE_4_DIR}/include/c++/v1 -L${STAGE_4_DIR}/lib/${TRIPLE}` | both libc++ header directories are explicit: the per-target one holds `__config_site`, the general one holds the headers. Both are needed for `<c++/v1>` to compile. |
| `-DCMAKE_EXE_LINKER_FLAGS` / `SHARED_LINKER_FLAGS` = `-Wl,-rpath,${STAGE_4_DIR}/lib/${TRIPLE}` | embed an RPATH pointing at stage 4's libc++ so the resulting binaries run without `LD_LIBRARY_PATH`. |
| `-DENABLE_LINKER_RPATH_BY_DEFAULT=ON` | make the driver add RPATHs automatically for runtime libraries; needed so sanitizer binaries from stage 7 carry their own RPATH. |
| `-DHAVE_CXX_ATOMICS64_WITHOUT_LIB=ON` / `-DHAVE_CXX_ATOMICS_WITHOUT_LIB=ON` | bypass LLVM's `CheckAtomic.cmake`. The check probes for a standalone `libatomic.so`, which does not exist when atomics come from compiler-rt. The values are correct; only the derivation fails. |
| `-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON` | keep the per-target runtime layout in stage 4's tree so the driver's default resource-dir lookup finds stage 3's installed runtimes. |
| `-DLLVM_ENABLE_POLLY=OFF` | legacy variable. Polly is not in `LLVM_ENABLE_PROJECTS` here. |
| `-DLLVM_USE_LINKER=lld` | LLVM's own build system uses lld for linking its binaries. |

### 5.7 `build_stage_5_crt`

**GNU bootstrap is removed here** (`apk del .gnu-bootstrap`). From this point,
every compiler is the GNU-free stage 4 clang.

Rebuilds compiler-rt crt and builtins into the final prefix
(`${LLVM_OUTPUT_RESOURCE_DIR}`). Structurally identical to stage 2 but driven by
stage 4 clang.

| Option | Reason |
| --- | --- |
| `-DCOMPILER_RT_BUILD_LIBFUZZER=OFF` | libFuzzer's private libc++ build conflicts with musl on `wint_t`; not needed. |
| `-DCMAKE_CXX_FLAGS` = `-isystem ${STAGE_4_DIR}/include/c++/v1 -isystem ${STAGE_4_DIR}/include/${TRIPLE}/c++/v1` | stage 4 clang's resource dir is empty, so the C++ headers are given explicitly, from stage 4's own tree. |
| all other flags | same reasoning as stage 2. |

The second `RUN` installs only the clang resource headers into `.llvm`.

### 5.8 `build_stage_6_runtimes`

Builds the sanitizers plus libunwind, libc++abi, libc++ into the final prefix.

| Option | Reason |
| --- | --- |
| `-DCOMPILER_RT_BUILD_SANITIZERS=ON` | this is the stage where ASan/UBSan/LSan/TSan are produced. |
| `-DCOMPILER_RT_BUILD_{ORC,XRAY,LIBFUZZER,MEMPROF,PROFILE}=OFF` | not required by the toolchain; ORC and XRay have build-order issues that would require a more invasive workaround. |
| `-DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON` | merge `libc++abi.a` into `libc++.a`, so users do not have to pass `-lc++abi` for static C++ links. |
| `-DLIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=OFF` | mandatory on musl, as in stage 3. |
| `-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON` and `-DCMAKE_INSTALL_RPATH="${STAGE_6_DIR}/lib"` | bake the runtime prefix into the shared libraries so they resolve each other from the final location. |
| `-DCMAKE_CXX_FLAGS` = `-resource-dir ${STAGE_5_DIR}/lib/clang/${CLANG_VER} -isystem ${STAGE_5_DIR}/lib/clang/${CLANG_VER}/include` | point stage 4 clang at stage 5's crt objects and clang resource headers. The C++ headers come from stage 4's own tree (via the driver's argv[0]-derived prefix). |
| `-DLLVM_ENABLE_RUNTIMES="compiler-rt;libunwind;libcxxabi;libcxx"` | all four, in dependency order. |

### 5.9 `build_stage_7_projects`

**The final toolchain.** Uses stage 4 clang via wrapper scripts, links against
stage 6's runtime tree, installs into `.llvm`.

Two wrappers are written to `.llvm-wrapper/`. Their purpose is to inject flags
that CMake cannot be relied upon to propagate to every subproject. The flag set:

| Wrapper flag | Reason |
| --- | --- |
| `-ferror-limit=1` | reduce noise; the build stops at the first error anyway. |
| `-Qunused-arguments` | suppress "argument unused during compilation" diagnostics for driver defaults like `-stdlib=libc++` that only matter at link time. |
| `-frtlib-add-rpath` | force RPATH emission for runtime libraries, covering the `-static-libsan` case that `ENABLE_LINKER_RPATH_BY_DEFAULT=ON` does not reach. |
| `-resource-dir ${STAGE_6_DIR}/lib/clang/${CLANG_VER}` | stage 4 clang's resource dir is empty by design; this points at stage 6's builtins and headers. |
| `-L${STAGE_6_DIR}/lib` | resolves `libLLVM.so`, `libclang-cpp.so` at link time. |
| `-L${STAGE_6_DIR}/lib/${TRIPLE}` | resolves `libc++.so.1`, `libc++abi.so.1`, `libunwind.so.1`. |
| `-fPIC` | Polly's `LLVMPolly.so` module and a few other targets do not receive `-fPIC` reliably through LLVM's CMake flags. The `LLVM_ENABLE_PIC=ON` variable does not always propagate into Polly's subdirectory. |
| `-nostdinc++` *(clang++ only)* | disable the driver's automatic C++ stdlib search, which would find stage 4's copied libc++ at `${STAGE_4_DIR}/include/c++/v1`. Without this, two libc++ trees are in the search path and `#include_next <string.h>` breaks (musl's `<string.h>` never gets reached; `::memcpy` remains undeclared). |
| `-isystem ${STAGE_6_DIR}/include/c++/v1` | full libc++ headers. |
| `-idirafter ${STAGE_6_DIR}/include/${TRIPLE}/c++/v1` | holds `__config_site` and the module map. `-idirafter` places it *after* the compiler's own system paths, so it cannot participate in an `#include_next` chain. |

CMake options:

| Option | Reason |
| --- | --- |
| `-DCMAKE_BUILD_RPATH="${STAGE_6_DIR}/lib/${TRIPLE};${STAGE_6_DIR}/lib"` | provide the build-tree RPATH entries that CMake cannot infer for libraries linked via `-L` (libc++ is not a CMake target). |
| `-DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF` | allow CMake to write a build RPATH that includes `llvm-build/lib/` for `libLLVM.so`, while the install RPATH is set separately. |
| `-DCMAKE_INSTALL_RPATH="${STAGE_6_DIR}/lib/${TRIPLE}:${STAGE_6_DIR}/lib"` | both directories, so installed binaries find both the C++ runtime and `libLLVM.so`. |
| `-DCMAKE_DISABLE_PRECOMPILE_HEADERS=ON` | PCH causes PIE/PIC mismatches when the wrapper's flags are not tracked by CMake's PCH machinery. |
| `-DLLVM_BUILD_LLVM_DYLIB=ON` / `LLVM_LINK_LLVM_DYLIB=ON` | a single `libLLVM.so` instead of dozens of archives; smaller binaries, faster links. |
| `-DLLVM_ENABLE_PROJECTS="bolt;clang;clang-tools-extra;lld;lldb;mlir;polly"` | all shipping projects except flang, deprecated-in-project-mode runtimes, test-only projects, and OpenCL kernels. |
| `-DLLVM_TARGETS_TO_BUILD=all` | every backend, for a cross-target compiler. |
| `-DLLVM_HOST_TRIPLE="${TRIPLE}"` / `-DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}"` | set the driver's default triple to `x86_64-alpine-linux-musl`. Without these, the installed driver reports `x86_64-unknown-linux-gnu` and looks for builtins under the wrong per-target directory. |
| `-DLLVM_ENABLE_EH=ON` / `RTTI=ON` | enable exception handling and RTTI, needed by lldb and parts of clang-tools-extra. |

### 5.10 `install_llvm`

Runtime image. Installs `zlib` and `zstd` (the shared-library dependencies of
the installed LLVM binaries), copies `.llvm` from stage 7, and sets `PATH`.

### 5.11 `test`

Verification stage. Removes `gcc` and `g++` from the base image, then rebuilds
clang and lld using only the toolchain from stage 7. If the toolchain still
needed GNU components, this build would fail. Includes
`CMAKE_BUILD_WITH_INSTALL_RPATH=ON` and an install RPATH pointing at the final
prefix, so build-tree tools (TableGen and the other generators) can find their
runtimes during the build.

## 6. Cross-cutting concerns

### 6.1 Two-phase bootstrap

Stages 1–4 produce a GNU-free clang. Stages 5–7 use that clang to produce the
final toolchain. The final toolchain is therefore "built by a GNU-free
compiler", not by itself. LLVM's own `LLVM_ENABLE_RUNTIMES` bootstrap mode is
never used — it builds clang and the runtimes in one nested CMake tree, which
conflicts with the constraint of orchestrating multi-stage builds by hand.

### 6.2 Per-target runtime layout

`LLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON` places runtime artifacts under:

```text
<prefix>/lib/clang/<version>/lib/<triple>/
```

for compiler-rt, and under `<prefix>/include/<triple>/c++/v1/` for the
per-target libc++ configuration header. The driver searches these paths by
default; without the option, compiler-rt lands under `lib/linux/` and is never
found.

The standalone `-S runtimes` invocation does not consult `CLANG_RESOURCE_DIR`;
the supported knob is `COMPILER_RT_INSTALL_PATH:PATH=lib/clang/<version>`, which
prepends the resource-dir component to the install path.

### 6.3 RPATH

Three different mechanisms interact:

- **Baked-in at link time** via `-Wl,-rpath,...` for stage 4's build, because
  its binaries must run in-tree before anything is installed.
- **Baked-in at install time** via `CMAKE_INSTALL_RPATH` for stages 6 and 7, so
  the shipped binaries find their runtimes from the final prefix.
- **Injected at runtime by the driver** via `-frtlib-add-rpath` for stage 7,
  because the driver's automatic RPATH logic is gated on the sanitizer being
  linked as a shared library and does not fire for `-static-libsan`.

The build RPATH and install RPATH are
separate. `CMAKE_BUILD_WITH_INSTALL_RPATH=OFF` allows CMake to emit a build
RPATH including `llvm-build/lib/` (for `libLLVM.so`); `CMAKE_BUILD_RPATH`
provides the entries for libc++, which CMake does not see because it was linked
via `-L`.

### 6.4 Wrapper scripts

CMake's flag propagation into LLVM subprojects is not uniform. Some targets link
through custom rules that drop `CMAKE_*_FLAGS`; some subprojects override the
parent's flags wholesale. The wrappers guarantee that a fixed set of flags is
present on every invocation, regardless of what each subproject's CMake does.

The trade-off is that the wrapper becomes load-bearing and must be kept
documented. Each flag carries a one-line comment in the Dockerfile explaining
which propagation gap it patches.

### 6.5 libc++ header layering

libc++'s `<string.h>` and friends are shims that use `#include_next` to reach
the C library. `#include_next` resumes the search *after* the directory where
the current file was found. If the same libc++ directory appears twice in the
search path — which happens when the driver adds `<prefix>/include/c++/v1`
implicitly and the wrapper adds the same directory explicitly — the shim is
found again, its include guard blocks it, and musl's header is never
reached. The result is undeclared `::memcpy` and a cascade of using-declaration
errors.

The fix is `-nostdinc++`, which disables the driver's automatic C++ stdlib
search and leaves only the wrapper's explicit paths. The C side does not need
the same treatment because the driver has no equivalent automatic C-header
lookup based on its own prefix.

### 6.6 Static linking

`clang -static foo.c` produces a fully static executable that runs on any modern
Linux, glibc or musl. This works because:

- compiler-rt builtins and crt objects are static archives;
- `libc++.a`, `libc++abi.a`, `libunwind.a` are static archives;
- `LIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON` merges libc++abi into
  libc++.a so `-lc++` is sufficient.

`clang++ -static foo.cpp` links against the same set. `-lc++abi` is not needed
after the merge.

### 6.7 Sanitizers

Sanitizers are built in stage 6. They are usable with `-fsanitize=address` (and
the others) on **dynamically linked** executables. A fully static ASan
executable is not supported by design: ASan interposes on libc at runtime, and
interposition requires the dynamic linker. The linker error about `_DYNAMIC` is
compiler-rt's deliberate guard rail, not a defect in the toolchain.

`-static-libsan` links the **sanitizer runtime** statically while leaving the
libc dynamic. This is the supported static-ish mode.

RPATH for sanitizer binaries is added by `-frtlib-add-rpath` in the
wrapper. Without it, the driver does not add an RPATH for `-static-libsan`, and
the binary fails at runtime with `libunwind.so.1: No such file or directory`.

## 7. Verification

After building `--target install_llvm`, the following commands confirm the
pipeline worked end to end.

### Linkage

```sh
readelf -d ${LLVM_INSTALL_DIR}/bin/clang | grep -E 'NEEDED|RUNPATH'
```

Expect `NEEDED` to list `libclang-cpp`, `libLLVM`, `libc++`, `libc++abi`,
`libunwind`, and musl's libc — no `libstdc++`, no `libgcc_s`. `RUNPATH` should
contain both `${LLVM_INSTALL_DIR}/lib/${TRIPLE}` and `${LLVM_INSTALL_DIR}/lib`,
each once.

### Triple and resource dir

```sh
${LLVM_INSTALL_DIR}/bin/clang -print-target-triple   # x86_64-alpine-linux-musl
${LLVM_INSTALL_DIR}/bin/clang -print-resource-dir    # ${LLVM_INSTALL_DIR}/lib/clang/24
```

### Static C

```sh
echo 'int main(void){return 0;}' > /tmp/t.c
${LLVM_INSTALL_DIR}/bin/clang -static /tmp/t.c -o /tmp/t
file /tmp/t        # "statically linked"
```

### Static C++ with exceptions and RTTI

```sh
echo '#include <stdexcept>
int main(){ try { throw std::runtime_error("x"); } catch(...) { return 0; } }' > /tmp/t.cpp
${LLVM_INSTALL_DIR}/bin/clang++ -static /tmp/t.cpp -o /tmp/tpp
file /tmp/tpp && /tmp/tpp
```

### Sanitizer

```sh
echo '#include <stdlib.h>
int main(void){ char *p = malloc(4); p[5] = 0; free(p); }' > /tmp/asan.c
${LLVM_INSTALL_DIR}/bin/clang -fsanitize=address -static-libsan -g /tmp/asan.c -o /tmp/asan
/tmp/asan        # must report heap-buffer-overflow; no LD_LIBRARY_PATH needed
```

### Backends

```sh
for t in x86_64-linux-musl aarch64-linux-musl riscv64-linux-musl; do
    ${LLVM_INSTALL_DIR}/bin/clang -target $t -c -x c /dev/null -o /dev/null && echo "$t OK"
done
```

### The GNU-free rebuild — the strongest check

```sh
docker build --target test ...
```

If this stage succeeds, the toolchain has no GNU dependency, because GCC is
absent from the image when it runs.
