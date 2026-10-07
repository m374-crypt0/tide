main() {
	cat<<EOF
# alpine-pinned

## introduction

This project exposes a build feature for a very basic alpine docker image used
as a foundation for more advanced ones.

The resulting image is based on official \`alpine:edge\` docker hub repository.
Each package installed in this image is strictly version-pinned for both
reproducibility and security reasons.
It means that updating the image is likely to fail because of package version
that does not exist anymore in latest alpine:edge official image.

It is thus recommended to push the image into a registry (either public, private
or self-hosted) once built.

## how to build

### default build

- go into the \`alpine-pinned\` directory
- issue the \`make build\` command

### customized build

- go into the \`alpine-pinned\` directory
- issue the \`make init\` command to create a \`.env\` file
- edit the \`.env\` file
- issue the \`make build\` command

## persist the image

You can push the image to a repository of your choosing with a \`docker
push...\` command
EOF
}

main
