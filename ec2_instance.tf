data "aws_ami" "coreos" {
  most_recent = true
  owners      = ["595879546273"]

  filter {
    name   = "name"
    values = ["CoreOS-stable*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2_linux_instance" {
    ami                    = "${data.aws_ami.coreos.id}"
    instance_type          = "${var.instance_size}"
    vpc_security_group_ids = ["${var.instance_sg_id}"]
    subnet_id              = "${var.instance_subnet_id}"
    key_name               = "${var.instance_key_name}"
    user_data              = "${replace(file("${path.module}/userdata.txt"),"/\\r/","")}"
    iam_instance_profile   = "${aws_iam_role.ec2_role.name}"
    
    root_block_device = {
      volume_size = 60
    }
    tags {
      Name = "${var.instance_name}"
    }
    lifecycle = {
        create_before_destroy = true
    }
}

resource "aws_eip" "concourse_elastic_ip" {
  vpc = true
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.ec2_linux_instance.id}"
  allocation_id = "${aws_eip.concourse_elastic_ip.id}"
}
