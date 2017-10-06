#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-5a922335
#
# Your subnet ID is:
#
#     subnet-aec9cad4
#
# Your security group ID is:
#
#     sg-c7eb27ad
#
# Your Identity is:
#
#     asas-fish
#

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-central-1"
}

variable "total_aws_instances" {
  default = 2
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  # ...
  #count = "${var.num_webs}"
  ami = "ami-5a922335"

  instance_type = "t2.micro"

  subnet_id              = "subnet-aec9cad4"
  vpc_security_group_ids = ["sg-c7eb27ad"]
  count                  = "${var.total_aws_instances}"

  tags {
    "Identity"    = "asas-fish"
    "environment" = "development"
    "location"    = "frankfurt"
    "name"        = "web ${count.index+1}/${var.total_aws_instances}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

#module "example" {
#  source = "./example-module"
#  command = "echo \"hoi henkjan\""
#}

terraform {
  backend "atlas" {
    name = "henkjan/training"
  }
}
