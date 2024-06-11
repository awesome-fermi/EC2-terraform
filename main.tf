terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {}

resource "aws_s3_bucket" "server_bucket" {
  bucket = "ubuntu-server-bucket-321"
  tags   = var.bucket_tag
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.server_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

terraform {
  backend "s3" {
    bucket = "ubuntu-server-bucket-321"
    key    = "project/terraform.tfstate"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = [var.ami_version]
  }
}

resource "aws_instance" "ubuntu_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  tags                   = var.instance_tag
  vpc_security_group_ids = [aws_security_group.allow.id]
  user_data = templatefile("user_data.tftpl", {
    server_owner = var.server_owner
  })
  #   depends_on = [aws_instance.database]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "static_ip" {
  instance = aws_instance.ubuntu_server.id
}

#  __generated__ by Terraform from "sg-0edee4f1a38a57d6c"
resource "aws_security_group" "allow" {
  description = var.security_group_description
  dynamic "egress" {
    for_each = var.egress_port_list
    content {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  }
  dynamic "ingress" {
    for_each = var.ingress_port_list
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
    }
  }
  name                   = var.security_group_name
  name_prefix            = null
  revoke_rules_on_delete = null
  tags                   = {}
  tags_all               = {}
  vpc_id                 = "vpc-0ace49963f051bcbb"
}
