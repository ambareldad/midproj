data "template_file" "elk_app" {
    template = "${file("${path.module}\\scripts\\elk\\elkinstall.sh")}"
    vars {
    config = <<EOF
     "enable_script_checks": true,
     "server": false
    EOF
  }

}

resource "aws_instance" "elk" {
  count                  = "${var.elkservers}"
  ami                    = "${var.ami}"
  instance_type          = "${var.aws_elkinstance_type}"
  subnet_id              = "${element(aws_subnet.midprojpublicsubnet.*.id, count.index)}"
  #subnet_id              = "${element(aws_subnet.midprojpublicsubnet.*.id,1)}"
  key_name               = "${var.aws_key_name}"
  
  iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"

  # vpc_security_group_ids = ["${aws_security_group.test.id}"]
  vpc_security_group_ids = ["${aws_security_group.midprojsecgrp.id}"]

  #wait for instance UP
  provisioner "local-exec" {
    command = "echo ${self.id}"
  }
 
  user_data = "${data.template_file.elk_app.rendered}"

  tags = {
      Name = "midprojelk"
      terraform = "true"
  }

  
}
output "elk_server - kibana on port 5601" {
  value = "${aws_instance.elk.*.public_ip}"
}