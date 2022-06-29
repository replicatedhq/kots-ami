# KOTS-AMI

Note: This is not an official supported repo. This repo should only be used as an example how to create an ami with kURL and kots preinstalled.

This repo uses Hashicorp Packer to create an AWS AMI. This image contains a kURL install script that will install Kubernetes and KOTS once on intial boot. This script is placed in a standard [cloud-init](https://cloudinit.readthedocs.io/en/latest/) location on the VM before the AMI snapshot is made.

## Technology:
* [cloud-init](https://cloudinit.readthedocs.io/en/latest/) - the standard location for running scripts on cloud VMs at boot
* [Hashicorp Packer](https://www.packer.io/) - to create an AMI
* [kURL](https://kurl.sh/) - to install Kubernetes and KOTS


packer init .
packer fmt .
packer validate .
packer build aws-ubuntu.pkr.hcl

## Install

## Docker

https://hub.docker.com/r/hashicorp/packer/

```bash
docker run <args> hashicorp/packer:light <command>
```

### Validate

```bash
docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    hashicorp/packer:latest \
    validate .
```

### Init

```bash
docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    hashicorp/packer:latest \
    init .
```

### Build

```bash
docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    hashicorp/packer:latest \
    build .
```
```bash
docker run \
    -v `pwd`:/workspace -w /workspace \
    hashicorp/packer:latest \
    build --var-file var.json template.json
```

docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    hashicorp/packer:latest \
    build .

## Contributors
* [tdensmore](https://github.com/tdensmore)
* [jdtate101](https://github.com/jdtate101)
* [jdewinne](https://github.com/jdewinne)

## References

* https://www.packer.io/docs
* https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer
