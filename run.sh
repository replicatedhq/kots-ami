#!/usr/bin/env bash

#docker run hashicorp/packer:light version

docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    hashicorp/packer:latest \
    build .

#packer build .