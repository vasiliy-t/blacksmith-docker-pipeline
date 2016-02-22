#!/bin/sh

# Create empty directory to act on
if [ ! -d "$REPOSITORY_NAME" ]; then
    mkdir -p $REPOSITORY_NAME
fi


# Initialize empty repository
docker run --rm \
       -v `pwd`:/data \
       leanlabs/git-builder:latest \
       -C $REPOSITORY_NAME init

# Fetch git ref to from target repository to act on
docker run --rm \
       -v `pwd`:/data \
       leanlabs/git-builder:latest \
       -C $REPOSITORY_NAME fetch $REPOSITORY_GIT_HTTP_URL $REF

# Checkout commit to act on
docker run --rm \
       -v `pwd`:/data \
       leanlabs/git-builder:latest \
       -C $REPOSITORY_NAME checkout $COMMIT

docker build -f `pwd`/$REPOSITORY_NAME/Dockerfile -t $DOCKER_IMAGE_NAME `pwd`/$REPOSITORY_NAME/

docker login --email $DOCKER_HUB_EMAIL --username $DOCKER_HUB_LOGIN --password $DOCKER_HUB_PASSWORD

docker push $DOCKER_IMAGE_NAME:latest

