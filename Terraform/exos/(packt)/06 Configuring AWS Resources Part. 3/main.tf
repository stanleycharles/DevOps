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
  cidr_block = var.vpc_cidr_block 
  tags = {
    "Name" = "Production ${var.main_vpc_name}"  # string interpolation
  }
}

# Create a subnet in the VPC
resource "aws_subnet" "web"{
  vpc_id = aws_vpc.main.id
  cidr_block = var.web_subnet  
  availability_zone = var.subnet_zone
  tags = {
    "Name" = "Web subnet"
  }
}

# Create an Intenet Gateway (IGW)
resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.main_vpc_name} IGW"
  }
}

# Associate the Internet Gateway to the default Route Table (RT)
resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"  # default route
    gateway_id = aws_internet_gateway.my_web_igw.id
  }
  tags = {
    "Name" = "my-default-rt"
  }
}