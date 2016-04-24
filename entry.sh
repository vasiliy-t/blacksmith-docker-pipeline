#!/bin/sh

docker rm -fv $COMMIT

# Create a data container to share source code
# across the builders
docker create -v /$COMMIT \
       --name $COMMIT \
       tianon/true:latest true

# Initialize empty repository
docker run \
       --volumes-from $COMMIT \
       -w "/$COMMIT" \
       leanlabs/git-builder:latest \
       -C ./ init

# Fetch git ref from target repository to act on
docker run --rm \
       --volumes-from $COMMIT \
       --workdir /$COMMIT \
       leanlabs/git-builder:latest \
       -C ./ fetch $REPOSITORY_GIT_HTTP_URL $REF

# Checkout commit to act on
docker run --rm \
       --volumes-from $COMMIT \
       --workdir /$COMMIT \
       leanlabs/git-builder:latest \
       -C ./ checkout $COMMIT

# Build Docker image
docker run --rm \
       -e COMMAND=build \
       -e IMAGE=$DOCKER_IMAGE_NAME \
       --volumes-from $COMMIT \
       -v /var/run/docker.sock:/var/run/docker.sock \
       --workdir /$COMMIT \
       leanlabs/image-builder

# Login to docker hub and push image
docker login --username $DOCKER_HUB_LOGIN --password $DOCKER_HUB_PASSWORD

docker push $DOCKER_IMAGE_NAME:latest
