# emacs

This is a resource image exposing a cutting edge `emacs` build.

## why

- cutting edge version exposes modern emacs' features
- built with the tide llvm toolchain then freed from any GNU depedency.

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
in other projects.
