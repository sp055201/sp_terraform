
variable "vpc_cidr" {
 type = list
 default =["11.0.0.0/16","12.0.0.0/16"]
}

variable "public_subnet_cidr" {
type = list
default =["11.0.1.0/24","12.0.1.0/24"]
}

variable "private_subnet_cidr" {
type = list
default =["11.0.2.0/24","12.0.2.0/24"]
}

variable "ami_id" {
  default     = "ami-0f403e3180720dd7e"
  description = "ami id for the ec2 instance"
  type        = string
}
variable "instance_type" {
  default     = "t3.xlarge"
  description = "instance class for ec2 instance"
  type        = string
}

