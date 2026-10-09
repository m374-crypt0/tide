# llvm

This is a resource image exposing a cutting edge `llvm` build.
This toolchain will contain all non-deprecated tools. The only thing that is not
built is `flang`.
This toolchain is freed from any GNU dependency and is able to build statically
linked executable able to run on any linux distribution.

## why

- because `llvm` is so cool.
- because `llvm` have many many tools to support native development projects.
- because GNU free llvm package provided by `alpine` packages are linked against
  GNU `stdlibc++`
- because a cutting edge `llvm` allow to enjoy latest `c++` standard additions

## how

### build

Edit the generated `.env` file to alter the behavior of the build.

- `make help` to display this message
- `make build` to build the alpine-pinned docker image
- `make rm` to delete the alpine-pinned docker image
- `make ps` to see tide services currently running (TODO: might be
  transversal)
- `make push` to push this service image into the local running registry
- `make export` TODO
- `make import` TODO

### use

It's a `resource` project. That means there are files and directory you can copy
in other projects. Besides, the `docker compose` file can (and should) be nerged
in other projects to leverage runtime settings such as environment variables and
volumes for instance.
