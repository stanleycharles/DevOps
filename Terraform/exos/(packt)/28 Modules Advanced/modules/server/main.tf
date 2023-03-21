
# Change the default security group
resource "aws_default_security_group" "default_sec_group" { 
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22  
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
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
    prefix_list_ids = []
  }

  tags = {
    "Name" = "Default Security Group"
  }
}

resource "aws_key_pair" "test_ssh_key" {
  key_name = "testing-ssh-key"
  public_key = file(var.public_key)
}


data "aws_ami" "latest_amazon_linux2"{  
owners = ["amazon"] 

most_recent =  true 
filter {
  name = "name"
  values = ["amzn2-ami-hvm-*-x86_64-gp2"] 
}

filter {
  name = "architecture"
  values = ["x86_64"]
}
}

# Launching an EC2 instance
resource "aws_instance" "my_vm" {
  ami = data.aws_ami.latest_amazon_linux2.id
  instance_type = var.server_type

  # subnet_id = aws_subnet.web.id
  subnet_id = var.subnet_id
  
  vpc_security_group_ids = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.test_ssh_key.key_name

  user_data = file("${var.script_name}")

  tags = {
    "Name" = "My EC2 Instance Amazon Linux 2"
    "X" = "123"
  }
}