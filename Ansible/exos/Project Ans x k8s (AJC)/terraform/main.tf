# Définir la région dans laquelle nous créons nos vm + keys d'utilisateurs IAM (aws cloud)
provider "aws" {
  region = var.AWS_REGION
  access_key =  var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

# Création d'un groupe de sécurité avec ouverture des ports ssh 22 et http :80
resource "aws_security_group" "devops" {
  name ="devops_grp3_sg"
  egress {
          from_port =  0
          to_port = 0
          protocol = "-1"
          cidr_blocks = ["0.0.0.0/0"]
  }
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
}

#Création d'une VM avec AWS EC2 selon les paramètres définis dans le fichier VARS
resource "aws_instance" "ec2" {
  ami = var.AWS_AMIS[var.AWS_REGION]
  instance_type = var.INSTANCE_TYPE
  key_name = "devops_group3-key"

  vpc_security_group_ids = [aws_security_group.devops.id]

  # Installation des différents packages afin de faire tourner Jenkins sur cette Vm (curl-java-jenkins) et Docker
  user_data = <<-EOF
    #!/bin/bash
    
    sudo apt-get update
    sudo apt install curl -y
    sudo apt install openjdk-11-jre -y

    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins -y
    sudo systemctl enable jenkins && systemclt start jenkins

    sudo apt-get install ca-certificates gnupg lsb-release -y
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    sudo usermod -a -G docker jenkins
    sudo reboot
  EOF

  tags = {
    Name = "devops_project"
  }
  
}

#afficher dans notre terminal d'installation l'ip de notre vm!
output "ip" {
  value = aws_instance.ec2.public_ip
}