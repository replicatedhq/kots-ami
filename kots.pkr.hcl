packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
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

/* variable "ami_id" {
  type    = string
  default = "ami-6f68cf0f"
} */
variable "ami_prefix" {
  type    = string
  default = "aws-ami"
}
variable "ami_region" {
  type    = string
  default = "us-west-2"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

source "amazon-ebs" "ubuntu" {
  #ami_name      = "packer-linux-aws-redis"
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "${var.instance_type}"
  region        = "${var.ami_region}"
  tags = {
      Name = "${var.ami_prefix}-ami"
  }
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
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
  # use '/var/lib/cloud/scripts/per-boot' to run at every startup
  provisioner "shell" {
    inline = [
      "sudo mv /tmp/install-kots.sh /var/lib/cloud/scripts/per-instance/",
      "sudo chmod 744 /var/lib/cloud/scripts/per-instance/install-kots.sh"
    ]
  }

  /* provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  } */


  }


