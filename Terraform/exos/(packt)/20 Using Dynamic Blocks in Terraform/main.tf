terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# 0. Configure the AWS Provider
provider "aws"{
  region     = "eu-central-1"
  access_key = "AKIA6QEFRZJACXBRGGON"
  secret_key = "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"
}


# 1. Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "Production ${var.main_vpc_name}"
  }
}

# 2. Create a subnet
resource "aws_subnet" "web"{
  vpc_id = aws_vpc.main.id
  cidr_block = var.web_subnet
  availability_zone = var.subnet_zone
  tags = {
    "Name" = "Web subnet"
  }
}

# 3. Create an Internet Gateway Resource
resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.main_vpc_name} IGW"
  }
}

# 4. Associate the IGW to the default RT
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

# 5. Setting the default Security Group
resource "aws_default_security_group" "default_sec_group" {
  vpc_id = aws_vpc.main.id
  # ingress {
  #   from_port = 22
  #   to_port = 22
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # dynamic "ingress"{
  #    for_each = var.ingress_ports
  #    content {
  #        from_port = ingress.value
  #        to_port = ingress.value
  #        protocol = "tcp"
  #        cidr_blocks = ["0.0.0.0/0"]
  #    }
  #  }
  
  # creating the ingress rules using dynamic blocks
  dynamic "ingress"{
     for_each = var.ingress_ports
     iterator = iport
     content {
         from_port = iport.value
         to_port = iport.value
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }
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
