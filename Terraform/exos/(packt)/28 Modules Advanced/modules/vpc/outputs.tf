output "main_vpc_id" {
    value = aws_vpc.main_vpc.id 
}

output "web_subnet_id" {
    value = aws_subnet.web.id
  
}