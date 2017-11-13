locals {
  external_name = "${ length(var.concourse_external_url) > 0 ? var.concourse_external_url : aws_eip.concourse_elastic_ip.public_ip}"
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.txt")}"

  vars {
    external_name      = "${local.external_name}"
    concourse_username = "${var.concourse_username}"
    concourse_password = "${var.concourse_password}"
    concourse_version  = "${var.concourse_version}"
    postgres_username  = "${var.postgres_username}"
    postgres_password  = "${var.postgres_password}"
    postgres_version   = "${var.postgres_version}"
    prepare_concourse_keys = "${base64encode(file("${path.module}/prepare_concourse_keys.sh"))}"
  }
}
