# Blacksmith CI Docker pipeline

[![](https://imagelayers.io/badge/blacksmithci/docker-pipeline:latest.svg)](https://imagelayers.io/?images=blacksmithci/docker-pipeline:latest 'Get your own badge on imagelayers.io')

Blacksmith CI docker images pipeline, implements full pipeline to build and publish docker images to hub.

Step by step flow:

1. Clone the source repo

2. Run docker build

3. Publish resulting image to docker hub with supplied credentials.

### Usage

```shell
docker run --rm \
    -e REPOSITORY_GIT_HTTP_URL="https://github.com/path-to/repo" \
    -e COMMIT=commithash \
    -e IMAGE="my/image" \
    -e DOCKER_HUB_USERNAME=qwerty \
    -e DOCKER_HUB_PASSWORD=qwerty \
    leanlabs/blacksmith-docker-builder:latest
```

This command will clone the repo from github, build the image and publish it to docker hub. **NOTE** There must be Dockerfile in the repo root dir, otherwise build will fail.

Image is stateless, it doesn't stores any credentials after or previous build info.

### Environment variables

**REPOSITORY_GIT_HTTP_URL** - git repository clone url, HTTP or HTTPS

**COMMIT** - git repo commit to checkout

**DOCKER_HUB_USERNAME** - your docker hub account username

**DOCKER_HUB_PASSWORD** - your docker hub account password

**IMAGE**  - docker image to build and push
