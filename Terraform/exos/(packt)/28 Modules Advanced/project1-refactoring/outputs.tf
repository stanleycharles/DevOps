
output "ec2_public_ip" {
    description = "The public IP of the EC2 instance."
    value = module.server.instance.public_ip

}

output "ami_id"{
    description = "ID of AMI"
    value = module.server.instance.ami
}
