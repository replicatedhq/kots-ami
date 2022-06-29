#!/usr/bin/env bash

set -e

GREEN='\033[1;32m'
NC='\033[0m' # No Color

read -p "Enter your AWS Access Key : " AWS_ACCESS_KEY_ID
read -sp "Enter your AWS Secret Access Key : " AWS_SECRET_ACCESS_KEY

echo -e "\n"
echo -e "$GREEN Running packer init."
docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    hashicorp/packer:latest \
    init .
echo -e "$GREEN Packer init done."

echo -e "$GREEN Running packer build."
docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    hashicorp/packer:latest \
    build .
echo -e "$GREEN Packer build done."