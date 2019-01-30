  data "template_file" "consul_client" {
  
  template = "${file("${path.module}\\templeates\\consul\\consultemp.sh.tpl")}"

  vars {
    consul_version = "1.4.0"
    config = <<EOF
     "enable_script_checks": true,
     "server": false
    EOF
  }

}