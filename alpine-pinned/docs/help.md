# alpine-pinned

This is a very basic docker image project aiming to provide a cutting edge
alpine image with strictly version-pinned packages.
It is only a build project, there is no service to run.

## why

- reproducibility: same version in a build, same outcome
- security: no implicit latest, reducing attack surface

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
