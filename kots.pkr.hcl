packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "script_path" {
  default = env("SCRIPT_PATH")
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "ami_prefix" {
  type    = string
  default = "replicated"
}
variable "ami_region" {
  type    = string
  default = "us-east-1"
}
variable "instance_type" {
  type    = string
  default = "m4.xlarge"
}
variable "slug" {
  type    = string
  default = "sentry-pro"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "${var.instance_type}"
  region        = "${var.ami_region}"
  tags = {
      Name = "${var.ami_prefix}-ami"
  }
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "kots"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  # upload the kots-install script to a non root directory
  provisioner "file" {
    destination = "/tmp/"
    source      = "./install-kots.sh"
  }
  # move the kots-install script to be executed on initial instance launch
  # use '/var/lib/cloud/scripts/per-instance' to run at every startup
  provisioner "shell" {
    inline = [
      "sed -i \"2 i export APP_SLUG=$APP_SLUG\" /tmp/install-kots.sh",
      "sudo mv /tmp/install-kots.sh /var/lib/cloud/scripts/per-instance/",
      "sudo chmod 744 /var/lib/cloud/scripts/per-instance/install-kots.sh"
    ]
    environment_vars = [
      "APP_SLUG=${var.slug}"
    ]
  }
}


