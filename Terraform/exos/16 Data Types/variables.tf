# type number
variable "web_port" {
    description = "Web Port"
    default = 80
    type = number
}

# type string
variable "aws_region" {
  description = "AWS Region"
  type = string
  default = "eu-central-1"
}

# type bool
variable "enable_dns" {
  description = "DNS Support for the VPC"
  type = bool
  default = true
}

# type list (of strings)
variable "azs" {
  description = "AZs in the Region"
  type = list(string)
  default = [ 
      "eu-central-1a", 
      "eu-central-1b", 
      "eu-central-1c" 
      ]
}

# type map
variable "amis" {
  type = map(string)
  default = {
    "eu-central-1" = "ami-0dcc0ebde7b2e00db",
    "us-west-1" = "ami-04a50faf2a2ec1901"
  }
}

# type tuple
variable "my_instance" {
    type = tuple([string, number, bool])  
    default = ["t2.micro", 1, true ]
}

# type object
variable "egress_dsg" {
    type = object({
        from_port = number
        to_port = number
        protocol = string
        cidr_blocks = list(string)
    })
    default = {
     from_port = 0,
     to_port = 65365,
     protocol = "tcp",
     cidr_blocks = ["100.0.0.0/16", "200.0.0.0/16", "0.0.0.0/0"]
    }
  
}