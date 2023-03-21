terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  access_key = "AKIA6QEFRZJACXBRGGON"
  secret_key = "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"
}


module "vpc" {
  source = "../modules/vpc"
}

module "server" {
  # path to the module's directory
  source = "../modules/server"
  
  # module inputs
  vpc_id = module.vpc.main_vpc_id
  subnet_id = module.vpc.web_subnet_id
  server_type = var.server_type
  public_key = var.public_key
  script_name = var.script_name
}

