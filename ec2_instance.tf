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
  ami                    = data.aws_ami.coreos.id
  instance_type          = var.instance_size
  vpc_security_group_ids = flatten([aws_security_group.RuleGroupLBHttpIn[*].id, var.instance_sg_id, aws_security_group.GroupWS[*].id])
  subnet_id              = element(var.private_sn, 0)
  key_name               = var.instance_key_name
  user_data              = replace(data.template_file.userdata.rendered, "/\\r/", "")
  iam_instance_profile   = aws_iam_role.ec2_role.name

<<<<<<< HEAD
  root_block_device {
    volume_size = var.instance_volume_size
=======
  root_block_device = {
    volume_size = "${var.instance_volume_size}"
>>>>>>> c398ad639c23913ea783eb43e38142fdc8b5b18a
  }

  tags = {
    Name = "${var.prefix}-${var.instance_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

