data "aws_ami" "coreos" {
  most_recent = true
  owners      = ["595879546273"]

  filter {
    name   = "name"
    values = ["CoreOS-${var.coreos_version}*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2_linux_instance" {
    ami                    = "${data.aws_ami.coreos.id}"
    instance_type          = "${var.instance_size}"
    vpc_security_group_ids = ["${aws_security_group.RuleGroupLBHttpIn.id}"]
    security_groups        = "${var.instance_sg_id}"
    subnet_id              = "${var.private_sn_a}"
    key_name               = "${var.instance_key_name}"
    user_data              = "${replace(data.template_file.userdata.rendered,"/\\r/","")}"
    iam_instance_profile   = "${aws_iam_role.ec2_role.name}"

    root_block_device = {
      volume_size = 60
    }
    tags {
      Name = "${var.prefix}-${var.instance_name}"
    }
    lifecycle = {
        create_before_destroy = true
    }
}
