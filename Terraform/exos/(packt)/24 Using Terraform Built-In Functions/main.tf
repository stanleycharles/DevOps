terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = "AKIA6QEFRZJACXBRGGON"
  secret_key = "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"
}


# Create a VPC.
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "Production ${var.main_vpc_name}."
  }
}

# Create a subnet in the VPC
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet
  availability_zone = var.subnet_zone
  tags = {
    "Name" = "web-subnet"
  }
}

# Create an Internet Gateway Resource
resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.main_vpc_name} IGW"
  }
}

# Associate the IGW to the default RT
resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }
  tags = {
    "Name" = "my-default-rt"
  }
}

# Setting Up the Default Security Group
resource "aws_default_security_group" "default_sec_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    "Name" = "Default Security Group"
  }
}

resource "aws_key_pair" "test_ssh_key" {
  key_name   = "testing-ssh-key"
  
  # reads the contents of a file at the given path and returns them as a string
  public_key = file("./test_rsa.pub")
}

locals {
  # timestamp() returns a UTC timestamp string in RFC 3339 format
  # formatdate() converts a timestamp into a different time format.
  time = formatdate("DD MM YYYY hh:mm", timestamp())
}

# Fetching and Spinning up an EC2 instance
resource "aws_instance" "my_vm" {
  # ami           = "ami-05cafdf7c9f772ad2"
  # built-in function
  # retrieves the value of a single element from a map, given its key
  ami = lookup(var.ami, var.region)

  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.web.id
  vpc_security_group_ids      = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.test_ssh_key.key_name

  # built-in function
  # reads the contents of a file at the given path and returns them as a string
  user_data = file("${path.root}/entry-script.sh")

  tags = {
    "Name" = "My EC2 Instance Amazon Linux 2"
    "X"    = "123"
  }
}