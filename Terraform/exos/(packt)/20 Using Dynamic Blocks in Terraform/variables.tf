variable "vpc_cidr_block" {
  description = "CIDR Block for the VPC"
  type = string
}

variable "web_subnet" {
  description = "Web Subnet"
  type = string
}

variable "subnet_zone" {
}

variable "main_vpc_name" {
}

variable "ingress_ports" {
  description = "List Of Ingress Ports"
  type = list(number)
  default = [22, 80, 110, 143]
}