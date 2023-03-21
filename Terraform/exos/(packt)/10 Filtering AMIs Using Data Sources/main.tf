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

# Create an Intenet Gateway
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

# Default Security Group
resource "aws_default_security_group" "default_sec_group" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.my_public_ip]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Default Security Group"
  }
}

# Create a key-pair resource
resource "aws_key_pair" "test_ssh_key"{
  key_name = "testing_ssh_key"
  public_key = file(var.ssh_public_key)

  
}

# Create a data source to fetch the latest Amazon Linux 2 Image in your region
data "aws_ami" "latest_amazon_linux2"{
  owners = ["amazon"]
  most_recent = true
  filter{
    name = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

# Spinning up an EC2 Instance
resource "aws_instance" "my_vm" {
  ami = data.aws_ami.latest_amazon_linux2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.web.id
  vpc_security_group_ids = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = true
  key_name = "testing_ssh_key"

  tags = {
    "Name" = "My EC2 Intance - Amazon Linux 2"
  }
}

# Connect to the server by running: ssh -i ./test_rsa ec2-user@EC2_PUBLIC_IP
# You may find the EC2 public ip on the EC2 Dashboard