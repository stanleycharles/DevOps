provider "aws" {
  region = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_vpc" "stanleyvpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
     Name = "stanley_VPC"
    }
}


resource "aws_subnet" "stanley-subnet-public" {
    vpc_id = aws_vpc.stanleyvpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-northeast-3a"
    tags = {
     Name = "stanley_subnet_public"
    }
}

resource "aws_route_table" "stanley-router" {
    vpc_id = aws_vpc.stanleyvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.stanley-internet.id
  }
}

resource "aws_internet_gateway" "stanley-internet" {
    vpc_id = aws_vpc.stanleyvpc.id
    tags = {
     Name = "stanley_internet"
    }
}

resource "aws_route_table_association" "stanley-rt_asso"{
    subnet_id = "${aws_subnet.stanley-subnet-public.id}"
    route_table_id = "${aws_route_table.stanley-router.id}"
}

resource "aws_instance" "ec2" {
  ami = var.AWS_AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name = "rsa_debian"
  subnet_id = aws_subnet.stanley-subnet-public.id
  vpc_security_group_ids = [aws_security_group.stan_secgrp.id]
  tags = {
  Name = "Stanley-debian-tf"
  }

user_data = <<-EOF
   #!/bin/bash
   sudo apt update
   sudo apt install -y apache2
   sudo systemctl start apache2
   sudo systemctl enable apache2
   sudo echo "<h1> hello </h1>" > /var/www/html/index.html
  EOF

 provisioner "local-exec" {
  command = "echo ${aws_instance.ec2.public_ip} > ip_address.txt"
 }

 connection {
  type = "ssh"
  user = "admin"
  private_key = file("/home/ubuntu/.ssh/id_rsa")
  host = self.public_ip
 }

 provisioner "remote-exec" {
  inline = [
   "sudo apt install -f -y update",
   "sudo apt install -f -y mariadb-server",
   "sudo systemctl start mariadb",
   "sudo systemctl enable mariadb",
   ]
  }

 provisioner "file" {
  source = "file.txt"
  destination = "/home/admin/file.txt"
 }
}

terraform {
 backend "s3" {
  bucket = "stanley-s3"
  key = "states/terraform.tfstate"
  region = "ap-northeast-3"
 }
}

output "ip" {
 value = aws_instance.ec2.public_ip
}

resource "aws_key_pair" "key_debian" {
  key_name   = "rsa_debian"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL3G7Ls4JgisUMtl6bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxfqVdXUgwS7kV6Ze8YLUgFT2kogn4ep7tyTjBVRLffLLUQ7IKK2SwlfkbvO0XwEFqvoHnO7uuBz8vH14DT2SwfqDm02Pc/MNnj0klNvlYv5mkEUlrQHgaTrpvgfqye7UGPrdXpgj7kZJBum2m8xynLxtxU51WoUG6sKXfqoIcLIWt1VLvq7mcZk30Rnik05wUKw3JANSx0WtSy3tShMR4/fsYd1QE/dy+9W0rXumPTBHX6HTCv7pWLgzUBur0DU/TdyF0QEMcQaMbDGCCWi8FL/p2UTQv78rxG1myp4fzkQ0df6Ata6PnzceSLAFXQUgHFh2v6aD14x4CCG0cY8laM5hcQMgiGEvkOLaRw6cgAuaFC/p6LPVG5oXwSJ6xvcs6+yQ5xw1mQujWpq7tb19S9sJBVl/N01CyKFe891FGr4QJgOR8Uvcl60PM= ubuntu@DESKTOP-ORCQGDK"
}

resource "aws_security_group" "stan_secgrp" {
 name = "stan_sg"
 vpc_id = aws_vpc.stanleyvpc.id
 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
 from_port = 80
 to_port = 80
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
}


