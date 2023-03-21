# Create a new VPC.
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "Production ${var.main_vpc_name}."
  }
} 

# Create a subnet for the VPC
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.web_subnet
  
  availability_zone = var.subnet_zone

  tags = { 
    "Name" = "web-subnet"
  }
}

# Create an Internet Gateway Resource
resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.main_vpc.id  
  tags = {
    "Name" = "${var.main_vpc_name} IGW"
  }
}

# Associate the IGW to the default RT
resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }
  tags = {
    "Name" = "my-default-rt"
  }
}
