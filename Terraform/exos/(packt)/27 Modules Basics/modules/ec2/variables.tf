variable "ami_id"{
    description = "AMI ID to provision"
    type = string
    default = "ami-04c921614424b07cd"
}

variable "instance_type"{
    description = "Instance type"
    type = string
    default = "t2.micro"
}

variable "servers" {
    description = "Number of instances to create"
    type = number
    default = 1
}