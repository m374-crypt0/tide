# non-root-user

This is a very basic docker image with a non-root user. Based on
`alpine-pinned` docker image.
It is only a build project, there is no service to run.

## why

- security: nothing run as root by default, nice addition to docker rootless
  mode.

## how

Edit the generated `.env` file to alter the behavior of the build.

- `make help` to display this message
- `make build` to build the alpine-pinned docker image
- `make rm` to delete the alpine-pinned docker image
- `make ps` to see tide services currently running (TODO: might be
  transversal)
- `make push` to push this service image into the local running registry
- `make export` TODO
- `make import` TODO
