# ide-web-app

This is an interactive project aiming to provide a full featured terminal IDE
for web application projects.
This image is based on `ide` and has all its features plus a bun installation.

## why

To get all that is necessary to build web application in typescript natively
using bun and enjoy all features of the `ide` project too.

## how

### build

Edit the generated `.env` file to alter the behavior of the build.

- `make help` to display this message
- `make build` to build the ide docker image
- `make up` to run the ide service
- `make login` to get into the shell
- `make down` to shut down the ide service and remove its container
- `make rm` to delete the ide docker image
- `make ps` to see tide services currently running (TODO: might be
  transversal)
- `make push` to push this service image into the local running registry
- `make export` TODO
- `make import` TODO

### use

It's an `interactive` project. It means it can be used as is or used as a base for
other projects by specifying its image as a base in a `FROM` directive.
Besides, the `docker compose` file can (and should) be merged in other projects
to leverage runtime settings such as environment variables and volumes for
instance.
