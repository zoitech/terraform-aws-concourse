locals {
  external_name = "${ length(var.concourse_external_url) > 0 ? var.concourse_external_url : "http://${aws_lb.concourse.dns_name}"}"
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.txt")}"

  vars {
    external_name      = "${local.external_name}"
    concourse_username = "${var.concourse_username}"
    concourse_password = "${locals.concourse_password}"
    concourse_version  = "${var.concourse_version}"
    postgres_username  = "${locals.postgres_username}"
    postgres_password  = "${var.postgres_password}"
    postgres_version   = "${var.postgres_version}"
    prepare_concourse_keys = "${base64encode(replace(file("${path.module}/prepare_concourse_keys.sh"),"/\\r/",""))}"
  }
}
