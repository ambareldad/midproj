Opsschool-Mid-Project

To deploy the environment run:

 

git clone https://github.com/Israel_israeli/my_repo.git

change variables.tf file
the sections:
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


cd my_repo/teraform
terraform init
terraform apply --auto-approve

 

 

To check your environment run:

 

Elasticsearch: curl XXXXXX:

dummyExporterService:  curl XXXXX:yyyy

Prometheus:   

Grafana:

Kibana:  ……...