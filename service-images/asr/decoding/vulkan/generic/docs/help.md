# advg (ASR Decoding Vulkan Generic)

This service project builds and runs a local Generic Decoding Automatic Speech
Recognition service using a Vulkan backend with Whisper.cpp from ggml.org.

This project can only work in a non-rootless docker as the running container
need to access host's devices.

## why

To provide:

- local speech transcription service from media files.
- local streamed audio transcription service.

## how

Edit the generated `.env` file to alter the behavior of the build.

- `make help` to display this message
- `make build` to build the advg docker image
- `make up` to run the advg decoding service locally
- `make model-fetch` to download the model specified in the .env file
  using the hugging face cli. The repository will be cached into a volume.
- `make model-set script=<path/to/script>` to specify the script to run
  for the selected model. The script will be cached into a volume and tied to
  the model.
- `make decode-up` to start the decoding service with the selected model
- `make decode-down` to stop the decoding service with the selected model
- `make down` to stop the advg decoding service and delete the container
- `make rm` to delete the advg docker image
- `make ps` to see tide services currently running (TODO: might be
  transversal)
- `make push` to push this service image into the local running registry
- `make export` TODO
- `make import` TODO
