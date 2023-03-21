region = "eu-central-1"
vpc_name = "DevOps Prod VPC"
vpc_cidr_block = "10.0.0.0/16"
web_subnet = "10.0.10.0/24"
subnet_zone = "eu-central-1a"

server_type = "t2.micro"
# image_name = "ami-0d527b8c289b4af7f"
image_name = "ami-05d34d340fb1d89e5" ##!! use Amazon Linux2 to have the ec2-user for ssh

public_key = "./test_rsa.pub"