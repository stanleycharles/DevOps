terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws"{
  region     = "eu-central-1"
  access_key = "AKIA52LJEQNMWCTT53NX"
  secret_key = "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"
}

# # Creating multiple EC2 instances using count
# resource "aws_instance" "server" {
#   ami = "ami-06ec8443c2a35b0ba"
#   instance_type = "t2.micro"
#   count = 3  # creating 3 resources
# }

# list of users to create
variable "users" {
  type = list(string)
  default = ["demo-user", "admin1", "john"]
}

# Creating more resources using count (loop technique)
resource "aws_iam_user" "test" {
  name = "${element(var.users, count.index)}" # retrieves an element from the list
  count = "${length(var.users)}" # returns the length of the list
}