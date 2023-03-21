terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
# !!Use your own access and secret keys!!
provider "aws"{
  region     = "eu-central-1"
  access_key = "AKIA52LJEQNMWCTT53NX"
  secret_key = "GAqkjt7DUbpIYA8EJZ7XzsI5jdYDsK+Z44OpRS3x"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block  # using variables
  tags = {
    "Name" = "Main VPC"
  }
}

# Create a subnet in the VPC
resource "aws_subnet" "web"{
  vpc_id = aws_vpc.main.id
  cidr_block = var.web_subnet   # using variables
  availability_zone = "eu-central-1a"
  tags = {
    "Name" = "Web subnet"
  }
}