#!/bin/sh

echo "Creating data container for build: $COMMIT"
docker create -v /$COMMIT \
       --name $COMMIT \
       tianon/true:latest true

echo "Get source to build $REPOSITORY_GIT_HTTP_URL:$COMMIT"
docker run --rm \
       --volumes-from $COMMIT \
       -w /$COMMIT \
       --entrypoint=/bin/sh  \
       leanlabs/git:latest -c "/usr/bin/git -C ./ init && \
/usr/bin/git -C ./ fetch $REPOSITORY_GIT_HTTP_URL $REF && \
/usr/bin/git -C ./ checkout $COMMIT"

echo "Build Docker image $IMAGE:latest"
docker run --rm \
       -e COMMAND=build \
       -e IMAGE=$IMAGE \
       -e TAG=latest \
       --volumes-from $COMMIT \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -w /$COMMIT \
       leanlabs/docker

echo "Publish docker image: $IMAGE:latest"
docker run --rm \
       -e COMMAND=publish \
       -e DOCKER_HUB_USERAME=$DOCKER_HUB_USERNAME \
       -e DOCKER_HUB_PASSWORD=$DOCKER_HUB_PASSWORD \
       -e IMAGE=$IMAGE \
       -e TAG=latest \
       -v /var/run/docker.sock:/var/run/docker.sock \
       leanlabs/docker

echo "Cleaning up"
docker rm -fv $COMMIT
