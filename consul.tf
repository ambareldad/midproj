# Create the user-data for the Consul server
data "template_file" "consul_server" {
  template = "${file("${path.module}\\templeates\\consul\\consultemp.sh.tpl")}"
  vars {
    config = <<EOF
     "server": true,
     "bootstrap_expect": 3,
     "ui": true,
     "client_addr": "0.0.0.0"
    EOF
  }
}
# Create the Consul cluster
resource "aws_instance" "consul_server" {
  count = "${var.consul_servers}"

  ami           = "${var.ami}"
  instance_type = "t2.micro"
  key_name      = "${var.aws_key_name}"

  iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"
  vpc_security_group_ids = ["${aws_security_group.midprojsecgrp.id}"]
  subnet_id              = "${element(aws_subnet.midprojpublicsubnet.*.id, count.index)}"
  tags = {
    Name = "midprojconsulserver-${count.index+1}"
    terraform = "true"
    consul_server = "true"
  }
  
  user_data = "${data.template_file.consul_server.rendered}"
}
output "Consulservers port 8500" {
  value = ["${aws_instance.consul_server.*.public_ip}"]
}
