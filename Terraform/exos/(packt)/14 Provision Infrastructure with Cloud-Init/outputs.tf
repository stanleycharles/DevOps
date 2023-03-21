output "ec2_public_ip" {
    description = "The public IP address of the EC2 instance."
    value = aws_instance.my_vm.public_ip
}

output "vpc_id" {
    description = "ID of the VPC"
    value = aws_vpc.main.id
    sensitive = false
}

output "ami_id" {
    description = "ID of AMI"
    value = aws_instance.my_vm.ami
    sensitive = false
}