terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  cloud {
    organization = "master-terraform"  # should already exist on Terraform cloud
    workspaces {
      name = "DevOps-Production"
    }
  }
}

# Configure the AWS Provider
provider "aws"{
  region     = "eu-central-1"
  access_key = "AKIA6QEFRZJACXBRGGON"
  secret_key = "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"
}

# Create a VPC.
resource "aws_vpc" "new" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "New DevOps VPC"
  }
}