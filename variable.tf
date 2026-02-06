variable "aws_region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "strapi-task4"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  default = "Linux_EC2instance"
}

variable "strapi_port" {
  default = 1337
}
