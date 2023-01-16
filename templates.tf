locals {
  external_name = "${ length(var.concourse_external_url) > 0 ? var.concourse_external_url : "http://${aws_lb.concourse.dns_name}"}"
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.txt")}"

  vars {
    prepare_concourse_keys = "${base64encode(replace(file("${path.module}/prepare_concourse_keys.sh"),"/\\r/",""))}"
    concourse_worker_service = "${base64encode(replace(file("${path.module}/concourse_worker.service"),"/\\r/",""))}"
    swap_service = "${base64encode(replace(file("${path.module}/swap.service"),"/\\r/",""))}"
    concourse_web_service = "${base64encode(replace(file("${path.module}/concourse_web.service"),"/\\r/",""))}"
    concourse = "${base64encode(replace(data.template_file.concourse.rendered,"/\\r/",""))}"
  }
}

data "template_file" "concourse" {
  template = "${file("${path.module}/concourse.sh")}"

  vars {
    external_name          = "${local.external_name}"
    concourse_username     = "${var.concourse_username}"
    concourse_password     = "${local.concourse_password}"
    concourse_version      = "${var.concourse_version}"
    postgres_endpoint      = "${aws_db_instance.postgres.address}"
    postgres_username      = "${var.postgres_username}"
    postgres_password      = "${local.postgres_password}"
  }
}


