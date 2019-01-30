  data "template_file" "grafana_app" {
    template = "${file("${path.module}\\scripts\\grafana\\grafanainstall.sh")}"

  vars {
    config = <<EOF
     "enable_script_checks": true,
     "server": false
    EOF
    try1 = <<EOF
    http://${aws_instance.midprojprometheus.public_ip}:9090
    EOF
  }
}

resource "aws_instance" "grafana_server" {
    count   = "1"
    ami     = "${var.ami}"
    instance_type   = "${var.aws_instance_type}"
    #subnet_id       = "${element(aws_subnet.midprojpublicsubnet.*.id,1)}"
    subnet_id       = "${element(aws_subnet.midprojpublicsubnet.*.id,count.index)}"
    key_name        = "${var.aws_key_name}"
    iam_instance_profile = "${aws_iam_instance_profile.consul-join.name}"
    tags = {
      Name = "midprojgrafana"
      terraform = "true"
    }

    vpc_security_group_ids = ["${aws_security_group.midprojsecgrp.id}"]
    
    user_data = "${data.template_file.grafana_app.rendered}"

}

output "grafanaserver on port 3000" {
  value = "${aws_instance.grafana_server.*.public_ip}"

}