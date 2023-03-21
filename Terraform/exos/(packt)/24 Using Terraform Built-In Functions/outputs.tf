
output "ec2_public_ip" {
  value       = aws_instance.my_vm.public_ip
  description = "The public IP of the EC2 instance"
}

output "ami_id" {
  description = "The ID of the AMI"
  value       = aws_instance.my_vm.ami
}

output "Datetime" {
  description = "Current Data and Time"
  value = local.time
}