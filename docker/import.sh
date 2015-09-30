#!/bin/bash

# This script is used to import a specified docker image from official registry to the private registry.

IMAGE="$1"
HOST="docker.peidan.me:5000"
RM="$2"

if [ "x$IMAGE" = "x" ]; then
    echo "Please enter image name."
    exit 1
fi

docker pull "$IMAGE"
docker tag "$IMAGE" "$HOST/$IMAGE"
docker push "$HOST/$IMAGE"
docker rm "$HOST/$IMAGE"

if [ "$RM" = "--rm" ]; then
    docker rm "$IMAGE"
fi
