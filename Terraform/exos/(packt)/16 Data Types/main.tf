terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# 0. Configuring the AWS Provider
provider "aws"{
  region     = var.aws_region
  access_key = "AKIA52LJEQNMWCTT53NX"
  secret_key = "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"
}


# 1. Creating a VPC.
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Production VPC."
  }
  enable_dns_support = var.enable_dns
} 

# 2. Creating a subnet
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.azs[2]

  tags = { 
    "Name" = "web-subnet"
  }
}

# 3. Creating an Internet Gateway Resource
resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.main_vpc.id  
  tags = {
    "Name" = "Web Internet Gateway"
  }
}

# 4. Associating the IGW to the default RT
resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }
  tags = {
    "Name" = "my-default-rt"
  }
  
}

# 5. Setting up the default Security Group
resource "aws_default_security_group" "default_sec_group" { 
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 22
    to_port = 22  
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

   ingress {
    from_port = var.web_port
    to_port = var.web_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port = var.egress_dsg["from_port"]
    to_port = var.egress_dsg["to_port"]
    protocol = var.egress_dsg["protocol"]
    cidr_blocks = var.egress_dsg["cidr_blocks"]
  }

  tags = {
    "Name" = "Default Security Group"    
  }
}

# 6. Creating a key-pair 
resource "aws_key_pair" "test_ssh_key"{
  key_name = "testing_ssh_key"
  public_key = file("./test_rsa.pub")
}

# 7. Creating an EC2 instance (Amazon Linux 2)
resource "aws_instance" "server" {
  ami           = var.amis["${var.aws_region}"]
  instance_type = var.my_instance[0]
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_default_security_group.default_sec_group.id]
 
  key_name = "testing_ssh_key"
  # cpu_core_count = var.my_instance[1]
  associate_public_ip_address = var.my_instance[2]
  count         = 1


  tags = {
    "Name" = "Amazon Linux 2"
  }
}

# output the public IP address of the instance
output "ec2_public_ip" {
    description = "The public IP address of the EC2 instance."
    value = aws_instance.server[0].public_ip
}

# Connect to the server by running: ssh -i ./test_rsa ec2-user@EC2_PUBLIC_IP