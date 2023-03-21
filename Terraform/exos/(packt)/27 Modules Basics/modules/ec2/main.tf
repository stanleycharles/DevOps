terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
   
 }
}

# Create an EC2 instance
resource "aws_instance" "server" {
  ami = var.ami_id
  instance_type = var.instance_type
  count = var.servers
}
