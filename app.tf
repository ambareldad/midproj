  data "template_file" "consul_client_app" {
    template = "${file("${path.module}\\scripts\\dummyexporter\\installdocker.sh")}"
  vars {
    config = <<EOF
     "enable_script_checks": true,
     "server": false
    EOF
  }

}
resource "aws_instance" "dummyexporterapp" {
  count                  = "${var.dummyexporterapp_servers}"
  ami                    = "${var.ami}"
  instance_type          = "${var.aws_instance_type}"
  subnet_id              = "${element(aws_subnet.midprojpublicsubnet.*.id, count.index)}"
  key_name               = "${var.aws_key_name}"
  
  iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"

  # vpc_security_group_ids = ["${aws_security_group.test.id}"]
  vpc_security_group_ids = ["${aws_security_group.midprojsecgrp.id}"]
  
  #wait for instance UP
  provisioner "local-exec" {
    command = "echo ${self.id}"
  }

  user_data = "${data.template_file.consul_client_app.rendered}"

  tags = {
      Name = "midprojcontainerapp--${count.index+1}"
      terraform = "true"
  }

  depends_on = ["aws_instance.consul_server","aws_instance.midprojprometheus"]
}
output "containerappip" {
  value = "${aws_instance.dummyexporterapp.*.public_ip}"
}
