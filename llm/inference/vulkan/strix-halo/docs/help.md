# strix-halo

This project builds and runs a local inference infrastructure for the AMD Strix
halo architecture hardware. It is base on a custom build of llama.cpp and can
load and use various compatible models with the vulkan backend.

This project can only work in a non-rootless docker as the running container
need to access host's devices.

## why

Local inference is the future.

## how

Edit the generated `.env` file to alter the behavior of the build.

- `make help` to display this message
- `make build` to build the strix-halo docker image
- `make up` to run the strix-halo inference service locally
- `make model-fetch` to download the model specified in the .env file
  using the hugging face cli. The repository will be cached into a volume.
- `make model-set script=<path/to/script>` to specify the script to run
  for the selected model. The script will be cached into a volume and tied to
  the model.
- `make model-up` to start the inference server with the selected model
- `make model-down` to stop the inference server with the selected model
- `make down` to stop the strix-halo inference service and delete the container
- `make rm` to delete the strix-halo docker image
- `make ps` to see tide services currently running (TODO: might be
  transversal)
- `make push` to push this service image into the local running registry
- `make export` TODO
- `make import` TODO
