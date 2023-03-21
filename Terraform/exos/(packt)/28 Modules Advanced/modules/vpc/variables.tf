variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "web_subnet" {
  default = "10.0.10.0/24"
}

variable "subnet_zone" {
    default = "eu-central-1a"
}

variable "main_vpc_name" {
  default = "New VPC"
}