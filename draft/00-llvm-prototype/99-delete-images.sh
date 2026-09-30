image_kind=tide

for image in $(docker image ls -q --filter "label=IMAGE_KIND=$image_kind"); do
    docker image rm -f "$image"
done
