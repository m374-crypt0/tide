# docker-in-docker

This is a very basic docker image capable of interacting with the docker daemon
on the host machine.

## why

- auto-referential environment: to be capable of working with docker inside a
  container is pretty valuable.
- You can even work on `tide` inside a container managed by `tide`

## how

### build

Edit the generated `.env` file to alter the behavior of the build.

- `make help` to display this message
- `make build` to build the alpine-pinned docker image
- `make login` to get into the shell
- `make rm` to delete the alpine-pinned docker image
- `make ps` to see tide services currently running (TODO: might be
  transversal)
- `make push` to push this service image into the local running registry
- `make export` TODO
- `make import` TODO

### run

It's an `interactive` project. It means it can be used as is or used as a base for
other projects by specifying its image as a base in a `FROM` directive.
Besides, the `docker compose` file can (and should) be nerged in other projects
to leverage runtime settings such as environment variables and volumes for
instance.
