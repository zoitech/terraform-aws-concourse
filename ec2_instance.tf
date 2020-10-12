data "aws_ami" "coreos" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CoreOS-${var.coreos_version}*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2_docker_instance" {
  ami                    = "${var.instance_ami}"
  instance_type          = "${var.instance_size}"
  vpc_security_group_ids = ["${aws_security_group.RuleGroupLBHttpIn.id}", "${var.instance_sg_id}", "${aws_security_group.GroupWS.id}"]
  subnet_id              = "${element(var.private_sn,0)}"
  key_name               = "${var.instance_key_name}"
  user_data              = "${replace(data.template_file.userdata.rendered,"/\\r/","")}"
  iam_instance_profile   = "${aws_iam_role.ec2_role.name}"

  root_block_device = {
    volume_size = "${var.instance_volume_size}"
  }

  tags {
    Name = "${var.prefix}-${var.instance_name}"
  }

  lifecycle = {
    create_before_destroy = true
  }
}
