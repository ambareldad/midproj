resource "aws_security_group" "midprojsecgrp" {
    name = "midproj_sg"
    description = "All security traffic rules for mid course project"
    vpc_id = "${aws_vpc.midprojvpc.id}"
    egress {
        from_port = "0"
        to_port   = "0"
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = "0"
        to_port   = "0"
        protocol  ="-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags{
      name = "midprojsecgrp"
      terraform = true
  }
}
