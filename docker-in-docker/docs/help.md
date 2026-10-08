# docker-in-docker

This is a very basic docker image capable of interacting with the docker daemon
on the host machine.
It is only a build project, there is no service to run.

## why

- auto-referential environment: to be capable of working with docker inside a
  container is pretty valuable.
- You can even work on `tide` inside a container managed by `tide`

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
