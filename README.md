# Blacksmith CI Docker builder

Blacksmith CI docker images builder, implements full pipeline to build and publish docker images to hub.

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
