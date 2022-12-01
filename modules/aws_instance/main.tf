resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
  filename        = "terraform-test.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "public_key" {
  key_name   = "terraform-test"
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_security_group" "security_group" {
  name        = "Security Group for Terraform Instance"
  description = "Enable SSH and HTTP Connection on Port 22 and 80"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.any_port
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.any_port
  }

  tags = {
    Name = "SG of Terraform Instance"
  }
}

resource "aws_volume_attachment" "ebs_attached" {
  device_name = "/dev/sdx"
  volume_id   = data.aws_ebs_volume.volume.id
  instance_id = aws_instance.pub_instance.id
}

resource "aws_instance" "pub_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = ["${aws_security_group.security_group.id}"]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "instance provisioned"
  }

  timeouts {
    create = "10m"
  }

  provisioner "file" {
    source      = "${path.root}/${var.bash_dir}/check_services.sh"
    destination = "/home/ubuntu/check_services.sh"

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_name}.pem")
      timeout     = "5m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x check_services.sh",
      "./check_services.sh",
      "rm check_services.sh",
    ]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_name}.pem")
      timeout     = "5m"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["${var.account_id}"]

  filter {
    name   = "name"
    values = ["ubuntu-terraform-instance"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ebs_volume" "volume" {
  most_recent = true

  filter {
    name   = "volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "tag:Name"
    values = ["instance_provisioned"]
  }
}
