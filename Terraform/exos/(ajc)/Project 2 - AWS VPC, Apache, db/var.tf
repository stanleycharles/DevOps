variable "AWS_REGION" {
 default = "ap-northeast-3"
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_AMIS" {
 type = map
 default = {
  "ap-northeast-1" = "ami-073770dc3242b2a06"
  "ap-northeast-3" = "ami-0e44d929367d23d2a"
 }
}
