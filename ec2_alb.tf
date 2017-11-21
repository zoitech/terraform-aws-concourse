resource "aws_lb_target_group" "concourse" {
  name     = "${var.prefix}-concourse-backend"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "concourse" {
  target_group_arn = "${aws_lb_target_group.concourse.arn}"
  target_id        = "${aws_instance.ec2_linux_instance.id}"
  port             = 8080
}

resource "aws_lb" "concourse" {
  name            = "${var.prefix}-concourse-alb"
  internal        = false
  security_groups = ["${aws_security_group.GroupLB.id}","${var.instance_sg_id}"]
  subnets         = ["${var.public_sn_a}","${var.public_sn_b}"]

  enable_deletion_protection = true
}

resource "aws_lb_listener" "concource" {
  load_balancer_arn = "${aws_lb.concourse.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.concourse.arn}"
    type             = "forward"
  }
}