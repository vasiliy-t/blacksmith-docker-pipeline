#!/bin/sh

CLONE_URL=`echo $EVENT_PAYLOAD | jq ".repository.clone_url" --raw-output`
COMMIT=`echo $EVENT_PAYLOAD | jq ".after" --raw-output`
REF=`echo $EVENT_PAYLOAD | jq ".ref" --raw-output`

echo "Creating data container for build: $COMMIT"
docker create -v /$COMMIT \
       --name $COMMIT \
       tianon/true:latest true

echo "Get source to build $CLONE_URL:$COMMIT"
docker run --rm \
       --volumes-from $COMMIT \
       -w /$COMMIT \
       --entrypoint=/bin/sh  \
       leanlabs/git:latest -c "/usr/bin/git -C ./ init && \
/usr/bin/git -C ./ fetch $CLONE_URL $REF && \
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
       -e DOCKER_HUB_USERNAME=$DOCKER_HUB_USERNAME \
       -e DOCKER_HUB_PASSWORD=$DOCKER_HUB_PASSWORD \
       -e IMAGE=$IMAGE \
       -e TAG=latest \
       -v /var/run/docker.sock:/var/run/docker.sock \
       leanlabs/docker

echo "Cleaning up"
docker rm -fv $COMMIT
