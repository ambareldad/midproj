Opsschool-Mid-Project

To deploy the environment run:

 

git clone https://github.com/ambareldad/midproj.git

change variables.tf file the sections:

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

cd midproj

terraform init
terraform apply --auto-approve
