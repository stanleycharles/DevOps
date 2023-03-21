provider "aws" {
  region = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_instance" "ec2" {
  ami = var.AWS_AMIS[var.AWS_REGION]
  instance_type = "c5.xlarge"
  key_name = "rsa_debian"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL3G7LxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxXFrCILjjX4JNNTgb3nfqVdXUgwS7kV6Ze8YLUgFT2kogn4ep7tyTjBV>}

resource "aws_security_group" "stan_secgrp" {
 name = "stan_sg"
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