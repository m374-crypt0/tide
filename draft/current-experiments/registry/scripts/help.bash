main(){
	cat <<EOF
# registry

This is the local docker image registry project for tide.
It is designed to be used as a local store for all \`tide\` images.

## why

To store \`tide\` built images locally. Indeed, certain images are very heavy to
build (llvm for instance). Besides, everything will run locally with this
registry.
Moreover, the registry is totally exportable from a machine to another if you
need.

## how

Edit the generated \`.env\` file to alter the behavior of the registry both at
build time and at run time.

- \`make help\` to display this message
- \`make build\` to build the registry docker image
- \`make up\` to run the registry locally
- \`make down\` to stop the registry and delete the container
- \`make rm\` to delete the registry docker image
- \`make ps\` to see tide services currently running (TODO: might be
  transversal)
- \`make push\` to push this service image into the local running registry
- \`make export\` TODO
- \`make import\` TODO

EOF
}

main
