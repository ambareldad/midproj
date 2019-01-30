    data "template_cloudinit_config" "consulprometheus"{
        part {
            content =  "${file("${path.module}\\templeates\\prometheus\\prometheustemplate.sh.tpl")}"
        }
        part {
            content =  "${data.template_file.consul_client.rendered}"
        }  
}


resource "aws_instance" "midprojprometheus" {
    ami           = "${var.ami}"
    instance_type = "${var.aws_instance_type}"
    key_name      = "${var.aws_key_name}"
    iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"
    vpc_security_group_ids = ["${aws_security_group.midprojsecgrp.id}"]
    subnet_id              = "${element(aws_subnet.midprojpublicsubnet.*.id, count.index)}"
    
    tags = {
       Name = "midprojprometheus"
       terraform = "true"
  }
    user_data = "${data.template_cloudinit_config.consulprometheus.rendered}"

    depends_on = ["aws_instance.consul_server"]
}
output "prometheuse_server on port 9090" {
  value = "${aws_instance.midprojprometheus.*.public_ip}"
}
