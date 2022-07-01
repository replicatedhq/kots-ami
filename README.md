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

### Docker

https://hub.docker.com/r/hashicorp/packer/

```bash
docker run <args> hashicorp/packer:light <command>
```

### Init

```bash
docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    hashicorp/packer:latest \
    init .
```

### Validate

```bash
docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    hashicorp/packer:latest \
    validate .
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

With AWS env vars: 

```bash
docker run \
    -v `pwd`:/workspace -w /workspace \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    hashicorp/packer:latest \
    build .
```

With `~/.aws` directory:

```bash
docker run \
    -v `pwd`:/workspace -w /workspace \
    -v ${HOME}/.aws:/root/.aws \
    -e AWS_PROFILE=${AWS_PROFILE} \
    -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
    hashicorp/packer:latest \
    build .
```

## Usage

Once an ec-2 instance is created (Check the kURL [System Requirements](https://kurl.sh/docs/install-with-kurl/system-requirements#cloud-disk-performance) for an example on sizing), you can browse to http://INSTANCE_IP:8800. THe password will be in /tmp/install.txt.

* It takes around 15 minutes for the k8s cluster to be up and running. Be patient.
* Make sure port `8800` is added to the inbound rules.

## Contributors
* [tdensmore](https://github.com/tdensmore)
* [jdtate101](https://github.com/jdtate101)
* [jdewinne](https://github.com/jdewinne)

## References

* https://www.packer.io/docs
* https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer

