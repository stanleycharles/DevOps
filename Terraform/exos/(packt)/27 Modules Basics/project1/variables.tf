variable "servers" {
  description = "No. of instances to spin up"
  type = number
}

variable "instance_type" {
  description = "Type of EC2 Intance"
  type = string
}

variable "ami_id" {
  description = "AMI Id"
  type = string
}