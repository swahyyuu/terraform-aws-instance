packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

data "amazon-ami" "autogenerated_1" {
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220912"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "ap-southeast-1"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "autogenerated_1" {
  ami_name                    = var.name
  associate_public_ip_address = true
  instance_type               = var.instance_type
  region                      = var.region_name
  source_ami                  = data.amazon-ami.autogenerated_1.id
  ssh_username                = var.ami_username
  vpc_id                      = "vpc-06db202553e029625"

  subnet_filter {
    filters = {
      "tag:Name" = "Subnet-public-Linux"
    }
    most_free = true
    random    = false
  }
}

source "amazon-ebsvolume" "ebsvolume" {
  associate_public_ip_address = true
  instance_type               = var.instance_type
  region                      = var.region_name
  source_ami                  = data.amazon-ami.autogenerated_1.id
  ssh_username                = var.ami_username
  vpc_id                      = "vpc-06db202553e029625"

  subnet_filter {
    filters = {
      "tag:Name" = "Subnet-public-Linux"
    }
    most_free = true
    random    = false
  }

  ebs_volumes {
    volume_type           = "gp2"
    device_name           = "/dev/xvdf"
    delete_on_termination = false
    tags = {
      Name = "instance_provisioned"
    }
    volume_size = 10
  }
}

build {
  sources = [
    "source.amazon-ebs.autogenerated_1",
    "source.amazon-ebsvolume.ebsvolume"
  ]

  provisioner "file" {
    source      = "./required_scripts/nginx.conf"
    destination = "/home/ubuntu/"
  }

  provisioner "shell" {
    only        = ["amazon-ebs.autogenerated_1"]
    script      = "./required_scripts/requirements_install.sh"
    max_retries = 2
    timeout     = "8m"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
