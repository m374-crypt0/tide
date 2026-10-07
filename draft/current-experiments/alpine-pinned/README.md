# alpine-pinned

## what

A base image with strict version pinning based on alpine edge.

## why

To serve as base image for more specialized future images with very same strict
version pinning strategy.

## how

Any behavior could be altered with environment variables embedded in an `.env`
file. A set of default values should work out of the box.

### build

- By setting explicit and pinned version for each packages.
- By providing a `world` file in the build context.
- By using docker `compose` facilities to build the image.
- By issuing `make build`, builds the image.

### run

- By using docker `compose` facilities to run a container base on the image.
- By issuing `make run` runs the container.
- By issuing `make login` enters into the container.
