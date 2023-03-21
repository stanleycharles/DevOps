terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws"{
  region     = "eu-central-1"
  access_key = "AKIA52LJEQNMWCTT53NX"
  secret_key = "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"
}

# Creating multiple EC2 instances using count
resource "aws_instance" "server" {
  ami = "ami-06ec8443c2a35b0ba"
  instance_type = "t2.micro"
  count = 3  # creating 3 resources
}