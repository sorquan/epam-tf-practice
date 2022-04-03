terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}


provider "aws" {
  region = "eu-central-1"
}


data "aws_vpcs" "some-project-vpcs" {}

data "aws_subnets" "some-project-subnets" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.some-project-vpcs.ids
  }
}

data "aws_security_groups" "some-project-sgs" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.some-project-vpcs.ids
  }
}


output "some-project-vpcs" {
  value = data.aws_vpcs.some-project-vpcs.ids
}

output "some-project-subnets" {
  value = data.aws_subnets.some-project-subnets.ids
}

output "some-project-sgs" {
  value = data.aws_security_groups.some-project-sgs.ids
}
