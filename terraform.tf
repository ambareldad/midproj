#Create Vpc
resource "aws_vpc" "midprojvpc" {
   cidr_block = "${var.vpc_cidr}"
   enable_dns_hostnames = "true"
   enable_dns_support   = "true"
   tags = { 
       Name = "terravpc"
       terraform = true
   }
}
#Create Internet gateway
resource "aws_internet_gateway" "midprojigw" {
  vpc_id = "${aws_vpc.midprojvpc.id}"
  tags = {
      name = "terraigw"
      terraform = true
  }
}
#Create Public subnet
resource "aws_subnet" "midprojpublicsubnet" {
    vpc_id = "${aws_vpc.midprojvpc.id}"
    cidr_block = "${var.public_subnet}"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "terrapublic"
        terraform = true
    }
}
#create public route table
resource "aws_route_table" "publicroute" {
    vpc_id = "${aws_vpc.midprojvpc.id}"
    
    route {
        cidr_block ="0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.midprojigw.id}"
    }
    tags = {
        name = "terrapublicroute"
        terraform = true
    }    
}
resource "aws_route_table_association" "name" {
  subnet_id = "${aws_subnet.midprojpublicsubnet.id}"
  route_table_id = "${aws_route_table.publicroute.id}"
}