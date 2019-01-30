variable "aws_access_key" {
    default = ""
} 
variable "aws_secret_key" {
    default = ""
} 
variable "aws_private_key_path" {
    default = ""
}
variable "aws_key_name" {
    default = ""
}
variable "aws_region" {
    default = "us-east-2"
}
variable "aws_instance_username" {
    default = "ubuntu"
}
variable "aws_instance_type" {
  default = "t2.micro"
}
variable "aws_elkinstance_type" {
  default = "t3.medium"
}
variable "vpc_cidr" {
    description = "CIDR for vpc"
    default =  "100.0.0.0/16"
}
variable "public_subnet" {
    description = "public sunbet cidr block"
    default = "100.0.100.0/24"
}
variable "consul_servers" {
  description = "The number of consul servers."
  default = 3
}
variable "consul_clients" {
  description = "The number of consul client instances"
  default = 1
}
variable "dummyexporterapp_servers" {
  description = "The number of consul servers."
  default = 2
}
variable "elkservers" {
  description = "The number of consul servers."
  default = 1
}
variable "ami" {
  description = "name of ssh key to attach to hosts"
  default = "ami-0653e888ec96eab9b"
}